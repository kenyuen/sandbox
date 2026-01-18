const express = require('express');
const httpProxy = require('http-proxy');
const { URL } = require('url');

const UPSTREAM_NODES = (process.env.UPSTREAM_NODES).split(',');
const CHECK_INTERVAL = parseInt(process.env.CHECK_INTERVAL || '5', 10) * 1000;
const CHECK_TIMEOUT = parseInt(process.env.CHECK_TIMEOUT || '2', 10) * 1000;
const MIN_HEALTHY = parseInt(process.env.MIN_HEALTHY || '1', 10);

const app = express();
const proxy = httpProxy.createProxyServer({});

let backends = UPSTREAM_NODES.map((s, i) => {
  const [host, port] = s.split(':');
  return { id: i, host, port, url: `http://${host}:${port}`, healthy: false };
});

const checkBackend = async (b) => {
  return new Promise((resolve) => {
    const u = new URL(b.url + '/');
    const http = require(u.protocol.slice(0, -1));
    const req = http.request({ hostname: u.hostname, port: u.port, path: '/', method: 'GET', timeout: CHECK_TIMEOUT }, (res) => {
      resolve(res.statusCode >= 200 && res.statusCode < 400);
    });
    console.info(`Checking backend ${b.url}`);
    req.on('error', () => resolve(false));
    req.on('timeout', () => { req.destroy(); resolve(false); });
    req.end();
  });
};

async function healthCheckLoop() {
  const checks = await Promise.all(backends.map(async (b) => {
    const ok = await checkBackend(b);
    b.healthy = ok;
    return ok;
  }));
  const healthyCount = checks.filter(Boolean).length;
  // ensure at least MIN_HEALTHY
  if (healthyCount >= MIN_HEALTHY) {
    // mark server healthy
    console.log('Healthy backends:', backends.filter(b=>b.healthy).map(b=>b.url));
  } else {
    console.warn('Not enough healthy backends:', healthyCount);
  }
}

// initial check
healthCheckLoop();
setInterval(healthCheckLoop, CHECK_INTERVAL);

// proxy all requests to a healthy backend selected round-robin
let rr = 0;
app.use((req, res) => {
  const healthy = backends.filter(b => b.healthy);
  if (healthy.length === 0) {
    return res.status(503).send('No healthy upstreams');
  }
  rr = (rr + 1) % healthy.length;
  const target = healthy[rr].url;
  proxy.web(req, res, { target }, (e) => {
    res.status(502).send('Bad gateway');
  });
});

const PORT = 9200;
app.listen(PORT, () => console.log(`Node proxy listening on ${PORT}, backends: ${UPSTREAM_NODES.join(',')}`));

FROM node:18-alpine
WORKDIR /app
COPY package.json /app/
RUN npm install --production --silent
COPY server.js /app/
ENV NODE_ENV=production
EXPOSE 9200
CMD ["node", "server.js"]

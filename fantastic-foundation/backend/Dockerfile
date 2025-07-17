# backend/Dockerfile
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
# during dev we'll use nodemon; adjust if you prefer plain `node`
CMD ["npm", "run", "dev"]

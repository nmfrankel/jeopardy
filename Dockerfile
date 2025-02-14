FROM node:lts-alpine

# Create app directory
WORKDIR /server

COPY package*.json ./

RUN npm install

COPY . .

ENV PORT=80
EXPOSE 80

# Build
# RUN npx prisma generate
RUN npm run build

CMD [ "npm", "run", "start" ]

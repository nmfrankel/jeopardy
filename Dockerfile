# FROM node:18

# WORKDIR /app

# COPY package*.json .

# RUN npm install

# COPY . .

# RUN npx svelte-kit sync

# RUN npx prisma generate

# RUN npx vite build

# ENV NODE_ENV production

# CMD [ "npm", "run", "preview" ]

FROM node:18 AS builder

WORKDIR /app

COPY package*.json .
RUN npm ci

COPY . .

ARG PUBLIC_SUPABASE_URL
ENV PUBLIC_SUPABASE_URL=${PUBLIC_SUPABASE_URL}
ARG PUBLIC_SUPABASE_ANON_KEY
ENV PUBLIC_SUPABASE_ANON_KEY=${PUBLIC_SUPABASE_ANON_KEY}

RUN npx svelte-kit sync
RUN npx prisma generate
RUN npm run build
RUN npm prune --production

FROM node:18
WORKDIR /app
# COPY --from=builder /app/build build/
# COPY --from=builder /app/node_modules node_modules/
COPY --from=builder /app/ .
EXPOSE 3000
ENV NODE_ENV=production
CMD [ "node", "build" ]

FROM node:hydrogen-buster-slim AS build
WORKDIR app

# RESTORE
COPY package.json /app
COPY yarn.lock /app
RUN yarn install

# BUILD
# COPY SOURCES
COPY . /app
RUN yarn build

FROM  denoland/deno:1.30.3

USER deno

WORKDIR /app

COPY --from=build /app/.output/ .

# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache ./server/index.ts

# The port that your application listens to.
EXPOSE 8000

CMD ["run", "--allow-net", "--allow-read", "--allow-env", "./server/index.ts"]

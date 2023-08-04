FROM node:14.17.0-alpine3.13 AS prepare
WORKDIR /app

COPY package.json package-lock.json ./

RUN npm i

COPY tsconfig.json tsconfig.paths.json config-overrides.js .eslintrc.js .eslintrc.prod.js .csscomb.json ./

COPY public public/
COPY src src/

CMD npm run start
EXPOSE 3000

FROM prepare AS build
RUN npm run build

FROM nginx:1.20.1-alpine as static

RUN rm -rf /usr/share/nginx/html
COPY --from=build /app/build /usr/share/nginx/html/
COPY env/docker/nginx/static.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

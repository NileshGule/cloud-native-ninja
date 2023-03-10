FROM node:19-alpine AS build

WORKDIR /app

COPY package*.json ./

# RUN npm install

RUN --mount=type=cache,id=npm,target=/root/.npm npm install 

COPY . .

RUN npm run build
# RUN --mount=type=cache,id=npm,target=/root/.npm npm build 

FROM nginx:alpine-slim

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

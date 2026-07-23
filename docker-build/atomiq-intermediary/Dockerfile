FROM node:24.9.0-alpine3.21 as builder
RUN apk --no-cache add curl
RUN npm install -g typescript@5
RUN curl -sf https://gobinaries.com/tj/node-prune | sh
WORKDIR /src
ADD .src .
RUN npm install --omit=dev
RUN tsc
RUN mv node_modules/yaml _yaml
RUN node-prune
RUN mv _yaml node_modules/yaml

FROM node:24.9.0-alpine3.21
WORKDIR /src
COPY --from=builder /src /src
CMD ["npm", "run", "start"]

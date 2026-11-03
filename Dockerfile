FROM node:25-trixie-slim AS deps

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

FROM gcr.io/distroless/nodejs22-debian13:nonroot

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY app.js package.json ./

ENV NODE_ENV=production

USER 65532:65532

EXPOSE 8080

CMD ["app.js"]
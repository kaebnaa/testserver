# 1. Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Хамгийн түрүүнд package файлуудыг хуулна, npm install хурдан ажиллахад тусална
COPY package.json package-lock.json* ./

RUN npm install

# Бусад бүх файлыг хуулна
COPY . .

# Build хийж dist папкийг үүсгэнэ
RUN npm run build

# 2. Production stage
FROM nginx:alpine

# Builder-аас dist папкийг nginx serve хийхэд хуулна
COPY --from=builder /app/dist /usr/share/nginx/html

# default порт 80 ашиглана
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

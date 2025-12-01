# Stage 1: Build the application
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY package.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Create the production image
FROM node:20-alpine

WORKDIR /usr/src/app

COPY package.json ./

# Install only production dependencies
RUN npm install --omit=dev

# Copy the built application from the builder stage
COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 3847

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Change ownership of the app directory
RUN chown -R appuser:appgroup /usr/src/app

# Switch to the non-root user
USER appuser

CMD ["npm", "start"]

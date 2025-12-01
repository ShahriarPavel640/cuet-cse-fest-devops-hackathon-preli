FROM node:20-alpine

WORKDIR /usr/src/app

COPY package.json ./

# Install only production dependencies
RUN npm install --omit=dev

COPY src ./src

EXPOSE 5921

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Change ownership of the app directory
RUN chown -R appuser:appgroup /usr/src/app

# Switch to the non-root user
USER appuser

CMD ["npm", "start"]

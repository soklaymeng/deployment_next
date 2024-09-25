# Base image for pulling the latest official Node.js image from Docker Hub
FROM node:latest

# Create the app directory
RUN mkdir -p /app

# Set working directory inside container
WORKDIR /app
COPY . .

# Install all dependencies in package.json
RUN npm install
RUN npm run build

# Expose the application port
EXPOSE 3001

# Run application when the container starts
CMD ["npm", "start"]

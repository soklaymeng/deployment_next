# Use official Node.js image from the Docker Hub
FROM node:18
WORKDIR /app

# Copy only package.json and package-lock.json (if present) to optimize layer caching
COPY package*.json ./

# Install dependencies
RUN npm 

# Copy the rest of the application code to the container
COPY . .

# Expose the port that your application will run on
EXPOSE 3000

# Start the application
CMD ["npm", "run", "dev"]

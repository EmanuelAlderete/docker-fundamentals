# Define the base image
# Using a slim version of Node.js 20 for a smaller image size
FROM node:20-slim

# Set the working directory inside the container
# This is where the application code will be copied
# and where commands will be run
WORKDIR /usr/src/app

# Copy package.json and yarn.lock files first
# This allows Docker to cache the dependencies layer
# and only re-run the installation if these files change
COPY package*.json ./

# Run yarn install to install dependencies
# This will create a node_modules directory with all the dependencies
# specified in package.json
RUN npm install

# Copy the rest of the application code into the container
# This includes all source files, configuration files, etc.
COPY . .

# Build the application
# This step compiles the source code into a production-ready format
# The build command is defined in package.json scripts
# It typically involves transpiling TypeScript to JavaScript, bundling files, etc.
# Ensure that the build command is defined in package.json
# under the "scripts" section as "build"
RUN npm run build

# Port configuration
# Expose port 3000 for the application
# This is the port on which the application will listen for incoming requests
# Ensure that the application is configured to listen on this port
EXPOSE 3000

# Start the application
# This command will run the application using yarn
# Ensure that the start command is defined in package.json
# under the "scripts" section as "start"
CMD ["npm", "run", "start"]
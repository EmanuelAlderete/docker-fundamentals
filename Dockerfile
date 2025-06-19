# Define the base image
# Using a slim version of Node.js 20 for a smaller image size
FROM node:20 AS build

# Set the working directory inside the container
# This is where the application code will be copied
# and where commands will be run
WORKDIR /usr/src/app

# Copy package.json and yarn.lock files first
# This allows Docker to cache the dependencies layer
# and only re-run the installation if these files change
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code into the container
# This includes all source files, configuration files, etc.
COPY . .

# Build the application
RUN npm run build
RUN npm install --omit=dev && npm cache clean --force

FROM node:20-alpine3.22 

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

# Port configuration
# Expose port 3000 for the application
# This is the port on which the application will listen for incoming requests
# Ensure that the application is configured to listen on this port
EXPOSE 3000

# Start the application
# This command will run the application using yarn
# Ensure that the start command is defined in package.json
# under the "scripts" section as "start"
CMD ["npm", "run", "start:prod"]
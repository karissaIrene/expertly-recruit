FROM nginx:alpine

# Copy the built static site into nginx's serve directory
COPY dist /usr/share/nginx/html

# Static site config with clean URLs and scanner-probe blocking
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
            server: {
                watch: {
                    usePolling: true,
                },
                host: true, // needed for the Docker Container port mapping to work
                strictPort: true,
                port: 5173, // you can replace this port with any port
            }
        }),
    ],
});

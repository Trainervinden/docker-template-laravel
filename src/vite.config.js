import {defineConfig} from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: [
                'resources/css/app.css',
                'resources/js/app.js',
                'resources/js/fa/all.min.js'
            ],
            refresh: true
        }),
    ],
    server: {
        hmr: {
            host: 'localhost',
        },
    }
});

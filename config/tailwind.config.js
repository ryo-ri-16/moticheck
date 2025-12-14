const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/views/**/*.html",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js"
  ],safelist: [
    'bg-blue-100',
    'bg-blue-300',
    'bg-green-100',
    'bg-green-300',
    'bg-green-500',
    'bg-green-600',
    'bg-yellow-100',
    'text-yellow-800',
    'bg-red-100',
    'text-red-700',
  ],
  theme: {
    extend: {
      colors: {
        ...colors
      }
    },
  },
  plugins: [require('@tailwindcss/line-clamp')],
};

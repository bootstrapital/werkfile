/** @type {import(tailwindcss).Config} */
module.exports = {
  content: [
    "./app/templates/**/*.html", // Scan templates
    "./app/static/js/**/*.js",   // Scan custom JS if needed
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require("daisyui"), // Enable DaisyUI
  ],
  // Optional: DaisyUI configuration
  daisyui: {
    themes: ["light", "dark", "cupcake"], // Add desired themes
  },
}

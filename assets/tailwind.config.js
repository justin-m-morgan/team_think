const colors = require("tailwindcss/colors");

module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        primary: colors.green,
        accent: colors.orange,
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};

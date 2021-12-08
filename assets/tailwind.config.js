const colors = require("tailwindcss/colors");

module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: "1rem",
        sm: "1rem",
        lg: "3rem",
        xl: "6rem",
        "2xl": "8rem",
      },
    },
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

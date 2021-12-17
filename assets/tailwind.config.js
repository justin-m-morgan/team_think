const colors = require("tailwindcss/colors");


module.exports = {
  content: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  darkMode: "media", // or 'media' or 'class'
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: "1rem",
        sm: "1rem",
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
};

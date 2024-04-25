module.exports = {
  mode: 'jit',
  content: [
    './app/views/**/*.{slim,erb,jbuilder,turbo_stream,js}',
    './app/decorators/**/*.rb',
    './app/helpers/**/*.rb',
    './app/inputs/**/*.rb',
    './app/assets/javascripts/**/*.js',
    './config/initializers/**/*.rb',
    './lib/components/**/*.rb'
  ],
  safelist: [
    {
      pattern: /bg-(red|green|blue|orange)-(100|200|400)/
    },
    {
      pattern: /text-(red|green|blue|orange)-(100|200|400)/
    },
    'pagy-*'
  ],
  variants: {
    extend: {
      overflow: ['hover']
    }
  },
  theme: {
    listStyleType: {
      none: 'none',
      disc: 'disc',
      decimal: 'decimal',
      square: 'square'
    }
  },
  plugins: [require('@tailwindcss/typography'), require('daisyui')],
  daisyui: {
    themes: [
      {
        // Custom theme named 'mytheme'
        apple: {
          "primary": "#3abf23",    // Map '500' from the apple color scheme to primary
          "secondary": "#b3f2a4",  // Map '200' from the apple color scheme to secondary
          "accent": "#83e86e",     // Map '300' from the apple color scheme to accent
          "neutral": "#3d4451",    // You can choose a neutral color or use the one from apple
          "base-100": "#edfce9",   // Map '50' from the apple color scheme to base-100
          // Add more custom colors as needed...
        },
      },
      
      "dark",
      "cupcake",
    ],
   
  },
};
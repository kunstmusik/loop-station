import { extendTheme } from "@chakra-ui/react";

const theme = extendTheme({
  fonts: {
    heading: "Jost, sans-serif",
    body: "Jost, sans-serif",
  },
  initialColorMode: 'dark',
  useSystemColorMode: false,

});

export default theme;

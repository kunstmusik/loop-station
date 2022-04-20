import { extendTheme } from "@chakra-ui/react";

const config = {
    fonts: {
      heading: "Jost, sans-serif",
      body: "Jost, sans-serif",
    },
    initialColorMode: 'dark',
    useSystemColorMode: false,
}
const theme = extendTheme({config});

export default theme;

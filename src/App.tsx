import { useEffect, useState } from "react";
import { Csound, CsoundObj } from "@csound/browser";
import logo from "./logo.svg";
import "./App.css";
import loopStationOrc from "./csound/loopstation.orc?raw";
import LoopControls from "./LoopControls";
import { Box, Button, Center, Heading, Text, VStack } from "@chakra-ui/react";

function App() {
  const [csound, setCsound] = useState<CsoundObj>();
  const [started, setStarted] = useState(false);
  useEffect(() => {
    if (!csound) {
      Csound().then((cs) => {
        setCsound(cs);
      });
    }
  }, [csound]);

  const startCsound = async () => {
    if (!csound) return;

    await csound.setOption("-+msg_color=false");
    await csound.setOption("-iadc");

    await csound.compileOrc(loopStationOrc);

    await (csound as any).enableAudioInput();
    await csound.start();
    csound.getAudioContext().then((ctx) => ctx?.resume());
    setStarted(true);
  };

  return (
    <VStack textAlign="center" width="100vw" h="100vh">
      <Text fontSize="3xl" fontWeight="bold" marginTop={2}>LOOP STATION</Text>
      {csound ? (
        started ? (
          <LoopControls csound={csound}></LoopControls>
        ) : (
          // <Center style={{height: "100vh"}}>
            <Button onClick={startCsound} margin={5}>Start Looper</Button>
          // </Center>
        )
      ) : (
        <div>Loading...</div>
      )}
    </VStack>
  );
}

export default App;

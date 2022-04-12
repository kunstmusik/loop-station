import {
  Button,
  Flex,
  SimpleGrid,
  Slider,
  SliderFilledTrack,
  SliderThumb,
  SliderTrack,
  Text,
} from "@chakra-ui/react";
import { CsoundObj } from "@csound/browser";
import { useState } from "react";

const LoopControl = ({
  csound,
  loopNumber,
}: {
  csound: CsoundObj;
  loopNumber: number;
}) => {
  const [recording, setRecording] = useState(false);
  const [recorded, setRecorded] = useState(false);
  const [db, setDb] = useState(0);

  return (
    <Flex key={loopNumber} direction="column">
      <Text
        fontSize="2xl"
        fontWeight="bold"
        textColor={recorded ? "#00ff00" : ""}
      >
        {loopNumber}
      </Text>
      <Button
        onClick={async () => {
          const command = `schedule(nstrnum("LoopBufferRecord"), 0, ${
            recording ? 0 : -1
          }, ${loopNumber})`;
          await csound.compileOrc(command);
          setRecording(!recording);
          setRecorded(true);
        }}
        colorScheme="red"
        variant={recording ? "solid" : "outline"}
      >
        REC
      </Button>
      <Slider
        aria-label="slider-ex-3"
        defaultValue={0}
        orientation="vertical"
        minH="32"
        margin="5"
        min={-60}
        max={0}
        step={0.1}
        flexGrow={1}
        onChange={(v) => {
          csound.setControlChannel(`Loop.${loopNumber}.gain`, v);
          console.log(`Loop.${loopNumber}.gain = ${v}`);
        }}
      >
        <SliderTrack>
          <SliderFilledTrack />
        </SliderTrack>
        <SliderThumb />
      </Slider>
      <Button
        onClick={() => {
          if (recording) {
            const command = `schedule(nstrnum("LoopBufferRecord"), 0, 0, ${loopNumber})`;
            csound.compileOrc(command);
          }
          csound.compileOrc(`loop_buffer_clear(${loopNumber})`);

          setRecording(false);
          setRecorded(false);
        }}
        disabled={!recorded}
      >
        Clear
      </Button>
    </Flex>
  );
};

const LoopControls = ({ csound }: { csound: CsoundObj }) => {
  return (
    <SimpleGrid columns={5} spacing={5} padding={5} w="100%" h="100%">
      {[0, 1, 2, 3, 4].map((n) => (
        <LoopControl csound={csound} loopNumber={n}></LoopControl>
      ))}
    </SimpleGrid>
  );
};

export default LoopControls;

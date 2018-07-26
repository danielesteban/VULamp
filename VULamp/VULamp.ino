#include <FastLED.h>

// Config
#define DATA_PIN 1
#define MIC_PIN A1
#define NUM_LEDS 9
#define NUM_READS 10
#define SENSITIVITY 3
#define BRIGHTNESS 90
CRGB leds[NUM_LEDS];

void setup() {
  // Unused pin (save power)
  pinMode(0, INPUT_PULLUP);
  // Setup led strip
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);
}

void loop() {
  static uint8_t hue = 0;
  static uint32_t lastTick = 0;

  // Sample mic
  uint16_t max = 0;
  uint16_t min = 1023;
  uint16_t sample;
  for (uint8_t i = 0; i < NUM_READS; i++) {
    sample = analogRead(MIC_PIN);
    max = max(sample, max);
    min = min(sample, min);
  }
  uint16_t amplitude = (max - min) / SENSITIVITY;

  // Output amplitude
  CRGB color = CHSV(hue + 16, 255, BRIGHTNESS);
  leds[4] = amplitude > 1 ? color : CRGB::Black;

  color = CHSV(hue + 12, 255, BRIGHTNESS);
  leds[3] = amplitude > 2 ? color : CRGB::Black;
  leds[5] = amplitude > 2 ? color : CRGB::Black;

  color = CHSV(hue + 8, 255, BRIGHTNESS);
  leds[2] = amplitude > 3 ? color : CRGB::Black;
  leds[6] = amplitude > 3 ? color : CRGB::Black;

  color = CHSV(hue + 4, 255, BRIGHTNESS);
  leds[1] = amplitude > 5 ? color : CRGB::Black;
  leds[7] = amplitude > 5 ? color : CRGB::Black;

  color = CHSV(hue, 255, BRIGHTNESS);
  leds[0] = amplitude > 8 ? color : CRGB::Black;
  leds[8] = amplitude > 8 ? color : CRGB::Black;

  FastLED.show();

  // Cycle through the whole color wheel
  uint32_t now = millis();
  if (now - lastTick >= 16) {
    lastTick = now;
    hue++;
  }
}

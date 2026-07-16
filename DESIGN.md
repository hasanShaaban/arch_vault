---
name: Cyanide Tech System
colors:
  surface: '#0e1416'
  surface-dim: '#0e1416'
  surface-bright: '#343a3c'
  surface-container-lowest: '#090f11'
  surface-container-low: '#161d1e'
  surface-container: '#1a2123'
  surface-container-high: '#242b2d'
  surface-container-highest: '#2f3638'
  on-surface: '#dde3e6'
  on-surface-variant: '#bbc9cd'
  inverse-surface: '#dde3e6'
  inverse-on-surface: '#2b3133'
  outline: '#859397'
  outline-variant: '#3c494d'
  surface-tint: '#36d8f8'
  primary: '#5de1ff'
  on-primary: '#003640'
  primary-container: '#00c6e6'
  on-primary-container: '#004e5c'
  inverse-primary: '#00687a'
  secondary: '#bbc6e1'
  on-secondary: '#253045'
  secondary-container: '#3e495f'
  on-secondary-container: '#adb8d3'
  tertiary: '#ffc594'
  on-tertiary: '#4c2700'
  tertiary-container: '#fe9f3f'
  on-tertiary-container: '#6c3a00'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#abedff'
  primary-fixed-dim: '#36d8f8'
  on-primary-fixed: '#001f26'
  on-primary-fixed-variant: '#004e5c'
  secondary-fixed: '#d7e2fe'
  secondary-fixed-dim: '#bbc6e1'
  on-secondary-fixed: '#101c30'
  on-secondary-fixed-variant: '#3c475d'
  tertiary-fixed: '#ffdcc1'
  tertiary-fixed-dim: '#ffb877'
  on-tertiary-fixed: '#2e1500'
  on-tertiary-fixed-variant: '#6c3a00'
  background: '#0e1416'
  on-background: '#dde3e6'
  surface-variant: '#2f3638'
typography:
  headline-lg:
    fontFamily: Geist
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Geist
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Geist
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Geist
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.02em
  headline-lg-mobile:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style
This design system targets a high-end SaaS and developer-centric audience. The brand personality is precise, technical, and forward-leaning, prioritizing clarity and a "pro" feel through a high-performance dark aesthetic. 

The visual style is **Corporate Modern** with a lean toward **Minimalism**. It utilizes a restricted color palette and rigorous structural alignment to create a sense of focused energy. The interface relies on subtle depth through tonal layering and light-sourced accents rather than heavy decorative elements.

## Colors
The palette is built on a "Deep Indigo" foundation to reduce eye strain while maintaining a premium tech feel.

- **Primary Background (#191e2b):** The base layer for all views.
- **Secondary Surface (#253045):** Used for elevated containers, cards, and navigation sidebars.
- **Accent/Primary (#00c6e6):** Reserved for high-priority actions, active states, and focus indicators.
- **Gradients:** Use a subtle linear gradient on large hero sections or main dashboard panels, transitioning from `#191e2b` at the top-left to `#253045` at the bottom-right at a 135-degree angle.

## Typography
The system uses **Geist** exclusively to maintain a technical, mono-inspired geometric rigor. 

Headings must always be white (`#ffffff`) to maximize contrast against the dark background. Body text uses the cool gray-blue (`#bfc0d1`) to create a secondary visual hierarchy that is legible but not overwhelming. Labels and small metadata should leverage the primary cyan to draw the eye to functional elements.

## Layout & Spacing
The layout follows a **Fluid Grid** model based on an 8px square baseline. 

- **Desktop:** 12-column grid with 24px gutters and 64px side margins.
- **Tablet:** 8-column grid with 20px gutters and 32px side margins.
- **Mobile:** 4-column grid with 16px gutters and 16px side margins.

Content blocks should use "stack" spacing (vertical margins) following the 8px scale to maintain a tight, organized developer-tool feel.

## Elevation & Depth
Depth is communicated through **Tonal Layers** rather than heavy shadows. 

1. **Floor:** `#191e2b` (Deep Indigo).
2. **Surface:** `#253045` (Dark Slate). This is used for cards and modals.
3. **Shadows:** Surfaces at elevation use a soft, diffused shadow: `0px 8px 24px rgba(0, 0, 0, 0.4)`. 
4. **Outer Glow:** For active primary elements (like a focused button), use a 4px blur glow of the primary cyan at 20% opacity.

## Shapes
The design system utilizes **ROUND_EIGHT** logic. 

Standard components (Buttons, Inputs, Cards) use a `0.5rem` (8px) corner radius. Large containers or featured sections may scale up to `1rem` (16px). This moderate rounding balances the technical "sharpness" of the Geist typeface with a modern, approachable UI feel.

## Components

- **Buttons:** Primary buttons feature a solid `#00c6e6` background with black text for maximum contrast. Secondary buttons use an outline of `#253045` with white text.
- **Cards:** Use the `#253045` surface color. Borders are unnecessary unless the card is interactive, in which case a 1px border of `#00c6e6` at 10% opacity can be applied on hover.
- **Inputs:** Background should be a slightly darker shade of the surface or a transparent stroke. Focus states must clearly use the `#00c6e6` accent.
- **Chips/Badges:** Use a subtle background of `#00c6e6` at 15% opacity with solid cyan text.
- **Lists:** Separators between list items should be `#ffffff` at 5% opacity to remain discreet.
- **Code Blocks:** A specialized component using a slightly darker version of the primary background to distinguish technical data from standard content.
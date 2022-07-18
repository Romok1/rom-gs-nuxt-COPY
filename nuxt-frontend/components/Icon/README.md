You can use SVGs from https://heroicons.dev/ to create more icons.

You just need to remove the class applied to them when you paste it into the template.

E.g.

```
<template>
  <svg
    fill="none"
    stroke="currentColor"
    viewBox="0 0 24 24"
    xmlns="http://www.w3.org/2000/svg"
  >
    <path
      stroke-linecap="round"
      stroke-linejoin="round"
      stroke-width="2"
      d="M14 5l7 7m0 0l-7 7m7-7H3"
    />
  </svg>
</template>
```

The "current color" property can be modified by applying a color to the component.

If you want to make icons more dynamic, you can easily do so with prop flags for example.

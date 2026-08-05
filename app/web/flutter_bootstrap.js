// Custom bootstrap: forces CanvasKit to load from the locally bundled
// "canvaskit/" assets instead of the default gstatic.com CDN, so the
// app doesn't depend on third-party CDN access.
{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/",
  },
});

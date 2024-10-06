## Design thoughts

- Setup MAUI environment
- Run the App to demonstrate functionality
- Identify key files for key functionality
  - `CameraSetup.cs`: Handles permissions, capture session, video preview layer, device and output.
  - `CameraProcessor.cs`: Takes the captured image, converts to image data and potentially grabs some hair image data / metadata (presumably in case a face was captured and detected).
  - `MainPage.xaml.cs`: Captures the image using renderer and camera setup and `stillImageOutput` as output.
  - `ImageShowcasePage.xaml.cs`: Acts as destination for delegate method for complete captured and processed images.

Notes:
Start off migrating the core functionality, integrate with proper architecture once fully understood and working.

FrameLayout fl;
void onResume() {
  super.onResume();
  runUi("setUI");
  size=height/12;
  getPermission();
}
void getPermission(){
  if (!hasPermission("android.permission.WRITE_EXTERNAL_STORAGE"))requestPermission("android.permission.WRITE_EXTERNAL_STORAGE", "initLocation");
  else{
    runUi("settingSurface");
    setEditor();
  }
}
void initLocation(boolean granted){
  if (granted) {
    runUi("settingSurface");
    setEditor();
  } else {
    getActivity().finish();
  }
}

void setUI() { 
  getSurface().getSurfaceView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
  //getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
}

void settingSurface() {
  fl=new FrameLayout(getContext());
  View surfaceView=getSurface().getSurfaceView(); 
  ViewGroup parent=(ViewGroup)surfaceView.getParent(); 
  parent.removeView(surfaceView); 
  parent.addView(fl); 
  fl.addView(surfaceView);
}
void runUi(String _method) {
  final String method=_method;
  runOnUiThread(new Runnable() {
    public void run() {
      getSurface().pauseThread();
      method(method);
      getSurface().resumeThread();
    }
  }
  );
}
FrameLayout.LayoutParams getLP(int w, int h) {
  FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(w, h); 
  return lp;
}
FrameLayout.LayoutParams getLP(int x, int y, int w, int h) {
  FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(w, h); 
  lp.leftMargin = x;
  lp.topMargin = y; 
  return lp;
}
final int MP=ViewGroup.LayoutParams.MATCH_PARENT;
final int WC=ViewGroup.LayoutParams.WRAP_CONTENT;
private boolean isDirectory(final String path) throws IOException{ 
  AssetManager assetManager = getActivity().getResources().getAssets();
  boolean isDirectory = false;
  try {
    if (assetManager.list(path).length > 0){
      isDirectory = true;
    }else{
      assetManager.open(path);
    }
  }catch (FileNotFoundException fnfe) {
    isDirectory = true;
  }
  return isDirectory;
}
private void copyFiles(final String parentPath, final String filename, final File toDir) throws IOException{
  AssetManager assetManager = getActivity().getResources().getAssets();
  String assetpath = (parentPath != null ? parentPath + File.separator + filename : filename);
  if (isDirectory(assetpath)) {
    if (!toDir.exists()) {
      toDir.mkdirs();
    } for (String child : assetManager.list(assetpath)) {
      copyFiles(assetpath, child, new File(toDir, child));
    }
  } else {
    copyData(assetManager.open(assetpath), new FileOutputStream(new File(toDir.getParentFile(), filename)));
  }
}
private void copyData(InputStream input, FileOutputStream output) throws IOException{
  int DEFAULT_BUFFER_SIZE = 1024 * 4; 	
  byte[] buffer = new byte[DEFAULT_BUFFER_SIZE]; 	
  int n = 0; 		
  while (-1 != (n = input.read(buffer))) { 
    output.write(buffer, 0, n);
  } 		
  output.close(); 		
  input.close();
}
void delete(final String dirPath)throws IOException{
  File file = new File(dirPath);
  delete(file);
}
void delete(final File file) throws IOException {
  if (!file.exists())return;
  if (file.isDirectory()) {
    for (File child : file.listFiles()) {
     delete(child);
    }
  }
  file.delete();
}
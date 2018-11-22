public class CustomEditText extends WebView{
  File file;
  String text;//file==nullの時のみ
  CustomEditText(Context context){
    super(context);
    clearCache(true);
    getSettings().setJavaScriptEnabled(true);
    getSettings().setDomStorageEnabled(true);
    getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
    setVerticalScrollBarEnabled(false);
    setHorizontalScrollBarEnabled(false);
    setScrollbarFadingEnabled(true);
    setScrollBarStyle(WebView.SCROLLBARS_OUTSIDE_INSET );
    setWebViewClient(new MyWebViewClient());
    setWebChromeClient(new MyWebChromeClient());
    setScrollContainer(false);
    MyJavaScriptInterface obj = new MyJavaScriptInterface();
    addJavascriptInterface( obj, "app" );
    loadUrl("file:///android_asset/textArea/index.html");
  }
  File getFile(){
    return file;
  }
  void load(){
    if(file==null)cannotOpen(text);
    else evaluateJavascript("javascript:if(typeof load == 'function')load('"+file.getPath()+"');",null);
  }
  void load(File file){
    setFocusable(true);
    setFocusableInTouchMode(true);
    this.file=file;
    this.text=null;
    evaluateJavascript("javascript:if(typeof load == 'function')load('"+file.getPath()+"');",null);
  }
  void cannotOpen(String text){
    setFocusable(false);
    setFocusableInTouchMode(false);
    this.file=null;
    this.text=text;
    evaluateJavascript("javascript:if(typeof nonFileload=='function')nonFileload('"+text.replace("'","\\'")+"')",null);
  }
  @Override public boolean overScrollBy(int deltaX, int deltaY, int scrollX, int scrollY, int scrollRangeX, int scrollRangeY, int maxOverScrollX, int maxOverScrollY, boolean isTouchEvent) {
    return false;
  }
  @Override public void scrollTo(int x, int y) { }
  @Override public void computeScroll() { }
  class MyWebChromeClient extends WebChromeClient{ 
    String console_="";
    @Override
    public boolean onConsoleMessage(ConsoleMessage cm) {
      console_=cm.sourceId().split("/")[cm.sourceId().split("/").length-1]+" "+ cm.lineNumber()+":"+cm.message()+"\n";
      console.setText(console_);
      return true;
    }
  }
  class MyWebViewClient extends WebViewClient {
    @Override public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error){
      println(error);
    }
    @Override
    public void onPageFinished(WebView view , String url){
      load();
    }
  }
  class MyJavaScriptInterface {
    @JavascriptInterface
    public String getText(String path){
      return join(loadStrings(path),"\n");
    }
    @JavascriptInterface
    public void upload(String path,String text){
      if(path!=null)saveStrings(path,text.split("\n"));
    }
  }
}

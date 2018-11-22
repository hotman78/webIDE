var path;
var nowLoading=false;
var editor = CodeMirror(document.body,{
  value: "",
  mode: "text/html",
  lineNumbers: true,
  lineWrapping: false,
  scrollbarStyle:null,
  fixedGutter:false});
editor.on('change', editor => {
  app.upload(path,editor.getValue());
});
function setup(){
  editor.setSize(windowWidth,windowHeight);
}
function load(path_){
  while(nowLoading||editor==null){}
  nowLoading=true;
  editor.setOption("readOnly", false);
  path=path_;
  editor.setValue(app.getText(path));
  if(getSuf(path)=="html")editor.setOption("mode","text/html");
  if(getSuf(path)=="js")editor.setOption("mode","javascript");
  if(getSuf(path)=="css")editor.setOption("mode","text/css");
  nowLoading=false;
}
function nonFileload(text){
  while(nowLoading||editor==null){}
  nowLoading=true;
  editor.setOption("readOnly",true);
  path=null;
  editor.setValue(text);
  nowLoading=false;
}
function getSuf(path){
  path.substring(path.lastIndexOf(".")+1);
}
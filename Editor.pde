ArrayList<CustomEditText> et=new ArrayList<CustomEditText>();
ArrayList<Button> buttons=new ArrayList<Button>();
ChooseFile cf;
CustomEditText cet;
Menu menu;
Console console;
ChooseRepository cr;
FrameLayout fl2;
int size;
void setEditor(){
  runUi("setChooseRepository");
  runUi("setMenu");
  runUi("setCodeEditor");
  runUi("setChooseFile");
  runUi("setConsole");
}
void setMenu(){
  menu=new Menu(getContext());
  fl.addView(menu, getLP(0,0, width,size));
}
void setChooseFile() {
  HorizontalScrollView hsb=new HorizontalScrollView(getContext());
  hsb.setHorizontalScrollBarEnabled(false);
  hsb.setFillViewport(true);
  cf=new ChooseFile(getContext());
  fl2.addView(hsb, getLP(0,0, width,size));
  hsb.addView(cf,getLP(MP,MP));
}
void setCodeEditor() {
  cet=new CustomEditText(getContext());
  fl2.addView(cet, getLP(0,size, width, height-size*5));
}
void setConsole(){
  ScrollView sb=new ScrollView(getContext());
  sb.setFillViewport(true);
  HorizontalScrollView hsb=new HorizontalScrollView(getContext());
  hsb.setFillViewport(true);
  fl2.addView(sb,getLP(0,height-size*4,width,size*3));
  sb.addView(hsb,getLP(MP,MP));
  console=new Console(getContext());
  hsb.addView(console,getLP(MP,MP));
}
void setChooseRepository(){
  cr=new ChooseRepository(getContext());
  fl.addView(cr,getLP(0,size,width,height-size));
}
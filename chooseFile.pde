class ChooseFile extends LinearLayout implements View.OnClickListener,View.OnLongClickListener,android.support.v7.widget.PopupMenu.OnMenuItemClickListener{
  int selected=0;
  File dir;
  File longClickDir;
  SharedPreferences data = getActivity().getSharedPreferences("DataSave", Context.MODE_PRIVATE);
  ChooseFile(Context context) {
    super(context);
    dir=new File(data.getString("project",null));
    setBackgroundColor(#002B85);
    open(dir);
    projectDir=dir;
    menu.titleSet();
  }
  void open(File dir){
    this.dir=dir;
    removeAllViews();
    buttons.clear();
    if(dir==null){
      cet.cannotOpen("Please open dir");
      return;
    }else if(!dir.exists()){
      cet.cannotOpen("Dir is not found");
      return;
    }
    if(!dir.getParentFile().getPath().equals(Environment.getExternalStorageDirectory()+"/webIDE")){
      add("../",dir.getParentFile());
    }
    int i=0;
    for(String fileName:dir.list()){
      if(new File(dir,fileName).isFile()){
        Button b=add(fileName,new File(dir,fileName));
        if(i==0){
          selectFileHighlight(b);
          cet.load((File)b.getTag());
        }
        i++;
      }
    }
    if(i==0){
      cet.cannotOpen("Please create new file");
    }
    for(String fileName:dir.list()){
      if(!new File(dir,fileName).isFile()){
        add(fileName,new File(dir,fileName));
      }
    }
    Button b=new Button(getContext());
    b.setBackgroundColor(color(0,0));
    b.setPadding(0,0,0,0);
    b.setText("+");
    b.setOnClickListener(this);
    b.setAllCaps(false);
    b.setTextColor(#FFFFFF);
    //b.setBackgroundColor(#002B85);
    b.setTag(null);
    addView(b, getLP(size, MP));
    buttons.add(b);
  }
  Button add(String text,final File file) {
    Button b=new Button(getContext());
    b.setPadding(0,0,0,0);
    b.setOnClickListener(this);
    b.setOnLongClickListener(this);
    if(file!=null&&file.isDirectory())b.setText(text+"/");
    else b.setText(text);
    b.setAllCaps(false);
    b.setTextColor(#FFFFFF);
    b.setBackgroundColor(color(0,0));
    //b.setBackgroundColor(#002B85);
    if(file.equals(cet.getFile())){
      selectFileHighlight(b);
    }
    b.setTag(file);
    addView(b, getLP(WC, MP));
    buttons.add(b);
    return b;
  }
  void onClick(View v) {
    if(v.getTag()==null){
      android.support.v7.widget.PopupMenu popup = new android.support.v7.widget.PopupMenu(getContext(),v);
      popup.getMenu().add("add file");
      popup.getMenu().add("add folder");
      popup.setOnMenuItemClickListener(this);
      popup.show();
      return;
    }
    if(((File)v.getTag()).equals(cet.getFile())){
      android.support.v7.widget.PopupMenu popup = new android.support.v7.widget.PopupMenu(getContext(),v);
      popup.getMenu().add("rename file");
      popup.getMenu().add("delete file");
      popup.setOnMenuItemClickListener(this);
      popup.show();
    }
    int i=buttons.indexOf(v);
    for(Button b:buttons){
      b.setBackgroundColor(color(0,0));
    }
    selectFileHighlight(buttons.get(i));
    if(!((File)v.getTag()).isDirectory()){
      cet.load((File)v.getTag());
    }else{
      open((File)v.getTag());
    }
  }
  boolean onMenuItemClick(final MenuItem item){
    AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
    final EditText et=new EditText(getContext()); 
    if(!item.getTitle().equals("delete file")&&!item.getTitle().equals("delete folder"))builder.setView(et);
    builder.setNegativeButton("Cancel", null);
    builder.setTitle(item.getTitle());
    builder.setPositiveButton("OK",new DialogInterface.OnClickListener(){
      @Override
      public void onClick(DialogInterface dialog, int which) {
        try{
          if(item.getTitle().equals("add file"))new File(dir,et.getText().toString()).createNewFile();
          if(item.getTitle().equals("add folder")) new File(dir,et.getText().toString()).mkdir();
          if(item.getTitle().equals("rename file"))cet.getFile().renameTo(new File(cet.getFile().getParent(),et.getText().toString()));
          if(item.getTitle().equals("delete file"))delete(cet.getFile());
          if(item.getTitle().equals("rename folder"))longClickDir.renameTo(new File(longClickDir.getParent(),et.getText().toString()));
          if(item.getTitle().equals("delete folder"))delete(longClickDir);
          open(dir);
        }catch(IOException e){
          e.printStackTrace();
        }
      }
    });
    builder.show();
    et.setFocusable(true);
    et.setFocusableInTouchMode(true);
    et.requestFocus();
    return true;
  }
  @Override
  public boolean onLongClick(View v){
    if((File)v.getTag()!=null&&((File)v.getTag()).isDirectory()){
      longClickDir=(File)v.getTag();
      android.support.v7.widget.PopupMenu popup = new android.support.v7.widget.PopupMenu(getContext(),v);
      popup.getMenu().add("rename folder");
      popup.getMenu().add("delete folder");
      popup.setOnMenuItemClickListener(this);
      popup.show();
      return true;
    }
    return false;
  }
  void selectFileHighlight(Button b){
    int BORDER_WEIGHT = 20;
    GradientDrawable borderDrawable = new GradientDrawable();
    borderDrawable.setStroke(BORDER_WEIGHT,#FB6DFF);
    LayerDrawable layerDrawable = new LayerDrawable(new Drawable[]{borderDrawable});
    layerDrawable.setLayerInset(0,-BORDER_WEIGHT,-BORDER_WEIGHT, -BORDER_WEIGHT, 0);
    b.setBackground(layerDrawable);
  }
}

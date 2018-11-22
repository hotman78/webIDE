class Menu extends FrameLayout implements View.OnClickListener,android.support.v7.widget.PopupMenu.OnMenuItemClickListener{
  ImageButton menu1,menu2,run;
  TextView title;
  File dir=new File(Environment.getExternalStorageDirectory()+"/webIDE");
  Menu(Context context) {
    super(context);
    setBackgroundColor(#002B85);
    menu1();
    title();
    menu2();
    run();
  }
  void menu1(){
    menu1=new ImageButton(getContext());
    AssetManager assets = getResources().getAssets();
    try{
      InputStream istream = assets.open("menu1.png");
      Bitmap bitmap = BitmapFactory.decodeStream(istream);
      menu1.setImageBitmap(bitmap);
    } catch (Exception e) {
      e.printStackTrace();
    }
    menu1.setScaleType(ImageView.ScaleType.FIT_XY);
    menu1.setBackgroundColor(color(0,0));
    menu1.setOnClickListener(this);
    menu1.setTag("menu1");
    addView(menu1,getLP(0,0,size,size));
  }
  void title(){
    title=new TextView(getContext());
    title.setTextColor(color(255));
    addView(title,getLP(size,0,width-size*3,size));
  }
  void titleSet(){
    title.setText(projectDir.getName());
  }
  void menu2(){
    menu2=new ImageButton(getContext());
    AssetManager assets = getResources().getAssets();
    try{
      InputStream istream = assets.open("menu2.png");
      Bitmap bitmap = BitmapFactory.decodeStream(istream);
      menu2.setImageBitmap(bitmap);
    } catch (Exception e) {
      e.printStackTrace();
    }
    menu2.setScaleType(ImageView.ScaleType.FIT_XY);
    menu2.setBackgroundColor(color(0,0));
    menu2.setOnClickListener(this);
    menu2.setTag("menu2");
    addView(menu2,getLP(width-size,0,size,size));
  }
void run(){
    ImageButton run=new ImageButton(getContext());
    AssetManager assets = getResources().getAssets();
    try{
      InputStream istream = assets.open("run.png");
      Bitmap bitmap = BitmapFactory.decodeStream(istream);
      run.setImageBitmap(bitmap);
    } catch (Exception e) {
      e.printStackTrace();
    }
    run.setScaleType(ImageView.ScaleType.FIT_XY);
    run.setBackgroundColor(color(0,0));
    run.setOnClickListener(this);
    run.setTag("run");
    addView(run,getLP(width-size*2,0,size,size));
  }
  public void onClick(View v){
    if(v.getTag().toString().equals("run")){
      Intent intent = new Intent(Intent.ACTION_VIEW);
      intent.setAction("android.intent.category.LAUNCHER");
      //intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
      intent.setClassName("processing.test.webideviewer", "processing.test.webideviewer.MainActivity");
      String url;
      try{
        url=new File(cf.dir,"index.html").toURI().toURL().toString();
      }catch(Exception e){
        e.printStackTrace();
        return;
      }
      intent.putExtra("URL",url);
      getActivity().startActivityForResult(intent,1); 
    }
    if(v.getTag().toString().equals("menu1")){
      if(!cr.isDrawerOpen(Gravity.LEFT))cr.openDrawer(Gravity.LEFT);
      else cr.closeDrawer(Gravity.LEFT);
    }
    if(v.getTag().toString().equals("menu2")){
      android.support.v7.widget.PopupMenu popup = new android.support.v7.widget.PopupMenu(getContext(),v);
      popup.getMenu().add("Create new project");
      popup.getMenu().add("Rename this project");
      popup.getMenu().add("Delete this project");
      popup.setOnMenuItemClickListener(this);
      popup.show();
    }
  }
@Override
  boolean onMenuItemClick(final MenuItem item){
    AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
    final EditText et=new EditText(getContext()); 
    if(!item.getTitle().equals("Delete this project"))builder.setView(et);
    builder.setNegativeButton("Cancel", null);
    builder.setTitle(item.getTitle());
    builder.setPositiveButton("OK",new DialogInterface.OnClickListener(){
      @Override
      public void onClick(DialogInterface dialog, int which) {
        try{
          if(item.getTitle().equals("Create new project")){
            if(et.getText().toString().equals(""))return;
            File file=new File(dir,et.getText().toString());
            file.mkdir();
            cr.openRep(file);
            cr.reload();
          }
          if(item.getTitle().equals("Rename this project")){
            if(et.getText().toString().equals(""))return;
            File file=new File(dir,et.getText().toString());
            projectDir.renameTo(file);
            cr.openRep(file);
            cr.reload();
          }
          if(item.getTitle().equals("Delete this project")){
            delete(projectDir);
            cr.reload();
            cf.open(null);
          }
        }catch(Exception e){
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
}
@Override
void onActivityResult(int requestCode,int resultCode,Intent data){
  String debug = data.getStringExtra("debug");
  console.setText(debug);
}
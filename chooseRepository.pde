File projectDir;
class ChooseRepository extends DrawerLayout implements DrawerLayout.DrawerListener{
  Repositories rep;
  LinearLayout ll;
  ChooseRepository(Context context){
    super(context);
    setDrawerListener(this);
    //setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);
    fl2=new FrameLayout(getContext());
    addView(fl2);
    rep=new Repositories(getContext());
    DrawerLayout.LayoutParams lp=new DrawerLayout.LayoutParams(width*2/3,height);
    lp.gravity=Gravity.LEFT;
    addView(rep,lp);
    rep.load();
  }
  void reload(){
    rep.load();
  }
  void openRep(File dir){
    SharedPreferences data = getActivity().getSharedPreferences("DataSave", Context.MODE_PRIVATE);
    SharedPreferences.Editor editor = data.edit();
    editor.putString("project",dir.getPath());
    editor.apply();
    projectDir=dir;
    cf.open(dir);
    menu.titleSet();
  }
  @Override
  void onDrawerClosed(View drawerView){
    
  }
  @Override
  void onDrawerOpened(View drawerView){
  }
  @Override
  void onDrawerSlide(View drawerView, float slideOffset){
    requestFocus();
  }
  @Override
  void onDrawerStateChanged(int newState){
    
  }
}
class Repositories extends ListView implements AdapterView.OnItemClickListener{
  HashMap<Integer,String> map=new HashMap<Integer,String>();
  ArrayAdapter<String> adapter;
  File dir=new File(Environment.getExternalStorageDirectory()+"/webIDE");
  Repositories(Context context){
    super(context);
    setBackgroundColor(#FFFFFF);
    adapter=new ArrayAdapter<String>(getActivity(), android.R.layout.simple_list_item_1);
    setAdapter(adapter);
    setOnItemClickListener(this);
  }
  void load(){
    adapter.clear();
    int i=0;
    for(String repositoryName:dir.list()){
      adapter.add(repositoryName);
      map.put(i,repositoryName);
      i++;
    }
  }
  public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
    File dir=new File(Environment.getExternalStorageDirectory()+"/webIDE/"+map.get(position));
    cr.openRep(dir);
    cr.closeDrawer(this);
  }
}
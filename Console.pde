class Console extends TextView{
  Console(Context context){
    super(context);
    //setBackgroundColor(#000000);
    setTextColor(#FFFFFF);
    GradientDrawable bgShape = new GradientDrawable();
    bgShape.setColor(Color.parseColor("#000000"));
    bgShape.setStroke(4,#AAAAAA);
    bgShape.setCornerRadius(2.5f);
    setBackground(bgShape);
    setTextIsSelectable(true);
  }
}
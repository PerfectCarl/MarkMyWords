
public class Window {
    private Gtk.Window win;
    private Gtk.TextView mk_textview;
    private WebKit.WebView  html_view;

    private API api;
    
    public signal void updated ();
    
    public Window (string[] args, API api) {
        Gtk.init (ref args);
        this.api = api;
    }

    private void update_html_view () {
        string text = mk_textview.buffer.text;
        string html = api.mk_converter(text);
        html_view.load_html (html, null);
        updated ();
    }

    public void run() {
        win = new Gtk.Window ();
        win.set_default_size (600, 480);
        win.window_position = Gtk.WindowPosition.CENTER;
        win.set_hide_titlebar_when_maximized (false);
        win.icon_name = "accessories-text-editor";
        win.destroy.connect (Gtk.main_quit);
        
        var toolbar = new Toolbar ();
        toolbar.set_title ("Mark My Words");
        win.set_titlebar (toolbar);
        
        var box = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        int width;
        win.get_size (out width, null);
        box.set_position (width/2);

        mk_textview = new Gtk.TextView ();
        box.add1 (mk_textview);

        html_view = new WebKit.WebView ();
        box.add2 (html_view);

        mk_textview.buffer.changed.connect (update_html_view);
        win.add (box);
        win.show_all();
        Gtk.main ();
    }
}
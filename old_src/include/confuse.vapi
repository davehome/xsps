/* confuse.vapi generated by vapigen, do not modify... or not */

[CCode (cheader_filename = "confuse.h")]
namespace Confuse {
	[Compact]
	[CCode (cname = "cfg_defvalue_t")]
	public struct DefaultValue {
		public Bool boolean;
		public double fpnumber;
		public long number;
		public weak string parsed;
		[CCode (cname = "string")]
		/*public weak string str;*/
		public char *str;
	}

	[Compact]
	[CCode (cname = "struct cfg_opt_t")]
	public struct Option {
		public weak DefaultValue def;
		public weak Flag flags;
		public weak FreeFunc freecb;
		public weak Func func;
		/*public weak string name;*/
		public char *name;
		public uint nvalues;
		public weak Callback parsecb;
		public weak PrintFunc pf;
		public void* simple_value;
		public weak Option[] subopts;
		public Type type;
		public weak ValidateCallback validcb;
		public weak Value values;
		[CCode (instance_pos = -1,  cname = "cfg_opt_getnbool")]
		public Bool getnbool (uint index);
		[CCode ( cname = "cfg_opt_getnfloat")]
		public double getnfloat (uint index);
		[CCode ( cname = "cfg_opt_getnint")]
		public long getnint (uint index);
		[CCode ( cname = "cfg_opt_getnptr")]
		public void* getnptr (uint index);
		[CCode ( cname = "cfg_opt_getnsec")]
		public Config getnsec (uint index);
		[CCode ( cname = "cfg_opt_getnstr")]
		public string getnstr (uint index);
		[CCode ( cname = "cfg_opt_gettsec")]
		public Config gettsec (string title);
		[CCode ( cname = "cfg_opt_name")]
		public string get_name ();
		[CCode ( cname = "cfg_opt_nprint_var")]
		public void nprint_var (uint index, GLib.FileStream fp);
		[CCode ( cname = "cfg_opt_print")]
		public void print (GLib.FileStream fp);
		[CCode ( cname = "cfg_opt_print_indent")]
		public void print_indent (GLib.FileStream fp, int indent);
		[CCode ( cname = "cfg_opt_set_print_func")]
		public unowned PrintFunc set_print_func (PrintFunc pf);
		[CCode ( cname = "cfg_opt_setnbool")]
		public void setnbool (Bool value, uint index);
		[CCode ( cname = "cfg_opt_setnfloat")]
		public void setnfloat (double value, uint index);
		[CCode ( cname = "cfg_opt_setnint")]
		public void setnint (long value, uint index);
		[CCode ( cname = "cfg_opt_setnstr")]
		public void setnstr (string value, uint index);
		[CCode ( cname = "cfg_opt_size")]
		public uint size ();
		[CCode ( cname = "cfg_numopts")]
		public int numopts ();
	} // class Option

	[Compact]
	/*
	 * free() is used here, because Vala mangages freeing opts, whereas
	 * using cfg_free() causes a double free.
	 */
	[CCode (cheader_filename = "confuse.h,stdlib.h", cname = "cfg_t", free_function = "free")]
	public class Config {
		public weak ErrFunc errfunc;
		public weak string filename;
		public weak Flag flags;
		public int line;
		public weak string name;
		public weak Option[] opts;
		public weak string title;
		[CCode ( cname = "cfg_init")]
		public Config([CCode (array_length = false)] Option[] opts, Flag flags);
		[CCode ( cname = "cfg_addlist")]
		public void addlist (string name, uint nvalues);
		[CCode ( cname = "cfg_error")]
		public void error (string fmt);
		[CCode ( cname = "cfg_getbool")]
		public Bool getbool (string name);
		[CCode ( cname = "cfg_getfloat")]
		public double getfloat (string name);
		[CCode ( cname = "cfg_getint")]
		public long getint (string name);
		[CCode ( cname = "cfg_getnbool")]
		public Bool getnbool (string name, uint index);
		[CCode ( cname = "cfg_getnfloat")]
		public double getnfloat (string name, uint index);
		[CCode ( cname = "cfg_getnint")]
		public long getnint (string name, uint index);
		[CCode ( cname = "cfg_getnptr")]
		public void* getnptr (string name, uint indx);
		[CCode ( cname = "cfg_getnsec")]
		public Config getnsec (string name, uint index);
		[CCode ( cname = "cfg_getnstr")]
		public string getnstr (string name, uint index);
		[CCode ( cname = "cfg_getopt")]
		public Option getopt (string name);
		[CCode ( cname = "cfg_getptr")]
		public void* getptr (string name);
		[CCode ( cname = "cfg_getsec")]
		public Config getsec (string name);
		[CCode (cname = "cfg_getstr")]
		public string getstr ([CCode (instance_pos = -1)]string name);
		[CCode ( cname = "cfg_gettsec")]
		public Config gettsec (string name, string title);
		[CCode ( cname = "cfg_include")]
		public int include (Option opt, int argc, out unowned string argv);
		[CCode ( cname = "cfg_init")]
		public Config init (Option[] opts, Flag flags);
		[CCode ( cname = "cfg_name")]
		public string get_name ();
		[CCode ( cname = "cfg_parse")]
		public int parse ([CCode (instance_pos = -1)]string filename);
		[CCode ( cname = "cfg_parse_boolean")]
		public int parse_boolean (string s);
		[CCode ( cname = "cfg_parse_buf")]
		public int parse_buf (string buf);
		[CCode ( cname = "cfg_parse_fp")]
		public int parse_fp (GLib.FileStream fp);
		[CCode ( cname = "cfg_print")]
		public void print (GLib.FileStream fp);
		[CCode ( cname = "cfg_print_indent")]
		public void print_indent (GLib.FileStream fp, int indent);
		[CCode ( cname = "cfg_set_error_function")]
		public ErrFunc set_error_function (ErrFunc errfunc);
		[CCode ( cname = "cfg_set_print_func")]
		public PrintFunc set_print_func (string name, PrintFunc pf);
		[CCode ( cname = "cfg_set_validate_func")]
		public ValidateCallback set_validate_func (string name, ValidateCallback vf);
		[CCode ( cname = "cfg_setbool")]
		public void setbool (string name, Bool value);
		[CCode ( cname = "cfg_setfloat")]
		public void setfloat (string name, double value);
		[CCode ( cname = "cfg_setint")]
		public void setint (string name, long value);
		[CCode ( cname = "cfg_setlist")]
		public void setlist (string name, uint nvalues);
		[CCode ( cname = "cfg_setnbool")]
		public void setnbool (string name, Bool value, uint index);
		[CCode ( cname = "cfg_setnfloat")]
		public void setnfloat (string name, double value, uint index);
		[CCode ( cname = "cfg_setnint")]
		public void setnint (string name, long value, uint index);
		[CCode ( cname = "cfg_setnstr")]
		public void setnstr (string name, string value, uint index);
		[CCode ( cname = "cfg_setopt")]
		public Value setopt (Option opt, string value);
		[CCode ( cname = "cfg_setstr")]
		public void setstr (string name, string value);
		[CCode ( cname = "cfg_size")]
		public uint size (string name);
		[CCode ( cname = "cfg_title")]
		public string get_title ();
		[CCode ( cname = "cfg_tilde_expand")]
		public static string tilde_expand (string filename);

	} // class Config

	[Compact]
	[CCode (cname = "cfg_value_t", free_function = "cfg_free_value")]
	public class Value {
		public Bool boolean;
		public double fpnumber;
		public long number;
		public void* ptr;
		public weak Config section;
		[CCode (cname = "string")]
		public weak string str;
		public Value();
	}

	[CCode (cname = "CFG_SUCCESS")]
	public const int CFG_SUCCESS;
	[CCode (cname = "CFG_FILE_ERROR")]
	public const int CFG_FILE_ERROR;
	[CCode (cname = "CFG_PARSE_ERROR")]
	public const int CFG_PARSE_ERROR;

	[CCode (cname = "cfg_flag_t", cprefix = "CFGF_", has_type_id = false)]
	public enum Flag {
		[CCode (cname = "CFGF_NONE")]
		NONE = 0,
		[CCode (cname = "CFGF_MULTI")]
		MULTI = 1,
		[CCode (cname = "CFGF_LIST")]
		LIST = 2,
		[CCode (cname = "CFGF_NOCASE")]
		NOCASE = 4,
		[CCode (cname = "CFGF_TITLE")]
		TITLE = 8,
		[CCode (cname = "CFGF_NODEFAULT")]
		NODEFAULT = 16,
		[CCode (cname = "CFGF_NO_TITLE_DUPES")]
		NO_TITLE_DUPES = 32
	}

	[CCode (cname = "cfg_bool_t",  cprefix = "cfg_", has_type_id = false)]
	public enum Bool {
		@false,
		@true
	}

	[CCode (cname = "cfg_type_t",  cprefix = "CFGT_", has_type_id = false)]
	public enum Type {
		NONE,
		INT,
		FLOAT,
		STR,
		BOOL,
		SEC,
		FUNC,
		PTR
	}

	/* function pointer typedefs */
	[CCode (cname = "cfg_callback_t",  has_target = false)]
	public delegate int Callback (Config cfg, Option opt, string value, void* result);
	[CCode (cname = "cfg_errfunc_t",  has_target = false)]
	public delegate void ErrFunc (Config cfg, string fmt, void *ap);
	[CCode (cname = "cfg_free_func_t",  has_target = false)]
	public delegate void FreeFunc (void* value);
	[CCode (cname = "cfg_func_t",  has_target = false)]
	public delegate int Func (Config cfg, Option opt, int argc, out unowned string argv);
	[CCode (cname = "cfg_print_func_t",  has_target = false)]
	public delegate void PrintFunc (Option opt, uint index, GLib.FileStream fp);
	[CCode (cname = "cfg_validate_callback_t",  has_target = false)]
	public delegate int ValidateCallback (Config cfg, Option opt);



} // namespace Confuse
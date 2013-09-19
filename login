using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Admin_Panel
{
    public partial class PQS_Quiz_login : Form
    {
        SqlConnection conn = new SqlConnection(@"Data Source=KASHI-PC;Initial Catalog=quiz;Persist Security Info=True;User ID=Student;Password=12345678");
        int p;
        SqlDataAdapter da;
        DataSet ds;
        DataTable dt;
        SqlCommand cmd;
        string test;
        string Urdu="Urdu";
        string check_lang_form;
        public PQS_Quiz_login()
        {
            InitializeComponent();
        }

        private void PQS_Quiz_login_Load(object sender, EventArgs e)
        {

        }
     
        private void textBox2_TextChanged(object sender, EventArgs e)
        {
            ValidateUserPassword();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (ValidateUserName() && ValidateUserPassword())
            {




                SqlCommand cmd = new SqlCommand();
                if (conn.State == ConnectionState.Open) { conn.Close(); }
                conn.Open();
                cmd.Connection = conn;
                cmd.CommandText = "Select * from [Login],[admin] WHERE [UserName]='" + textBox1.Text + "' AND [Password]='" + textBox2.Text + "'  OR [Examiner-ID]='" + textBox1.Text + "' AND [Password]='" + textBox2.Text + "' ";
                SqlDataReader re = cmd.ExecuteReader();
                // session["user"] = label4.Text;


                if (re.Read())
                {


                    //  MessageBox.Show("Access Granted....");
                    string a = re["Examiner-ID"].ToString();
                    // string s = re["std_id"].ToString();

                    string a1 = textBox1.Text;
                    //quizid d = new quizid(tb_UserName.Text, p);
                    if (a1 == a)
                    {

                        this.Hide();
                        Admin_Control_Panel admin1 = new Admin_Control_Panel();
                        admin1.Show();
                        //Admin_Control_Panel admin = new Admin_Control_Panel();
                        //admin.Show();
                        //this.Close();
                    }
                    else
                    {
                        this.Hide();

                        if (conn.State == ConnectionState.Open) { conn.Close(); }
                        conn.Open();
                        SqlCommand cmd2 = new SqlCommand();
                        SqlCommand cmd1 = new SqlCommand();
                        cmd1.Connection = conn;
                        cmd2.Connection = conn;
                        cmd2.CommandText = "Select q_type from Sessions where std_id='" + textBox1.Text + "'";

                        cmd1.CommandText = "Select Quiz_Language from Quiz_Info where Status=1";

                        SqlDataReader re1 = cmd2.ExecuteReader();
                        if (re1.Read())
                        {


                            string check_form = re1["q_type"].ToString();
                            re1.Close();
                            SqlDataReader re2 = cmd1.ExecuteReader();
                            if (re2.Read())
                            {
                                check_lang_form = re2["Quiz_Language"].ToString();

                            }
                            if (check_form.Trim() == "Multiple Choice" && check_lang_form.Trim() == "English")
                            {
                                // MessageBox.Show("User Already  exit");
                                p = 1;
                                Start_Quiz start = new Start_Quiz(textBox1.Text, p, test);
                                start.Show();
                            }
                            else if (check_form.Trim() == "Fill In The Blanks" && check_lang_form.Trim() == "English")
                            {
                                p = 1;
                                Start_Quiz_FIB fib = new Start_Quiz_FIB(textBox1.Text, p, test);
                                fib.Show();
                            }
                            else if (check_form.Trim() == "True False" && check_lang_form.Trim() == "English")
                            {

                                p = 1;
                                Start_Quiz_TF tf = new Start_Quiz_TF(textBox1.Text, p, test);
                                tf.Show();

                            }
                            else if (check_form.Trim() == "True False" && check_lang_form.Trim() == "Urdu")
                            {
                                p = 1;
                                Start_Quiz_URTF urtf = new Start_Quiz_URTF(textBox1.Text, p, test);
                                urtf.Show();

                            }
                            else if (check_form.Trim() == "Multiple Choice" && check_lang_form.Trim() == "Urdu")
                            {
                                p = 1;
                                Start_Quiz_URMCQs urmcq = new Start_Quiz_URMCQs(textBox1.Text, p, test);
                                urmcq.Show();


                            }
                            ////quizid a11 = new quizid(tb_UserName.Text, p);
                            ////a11.Show();
                            //GetPreviousSession(tb_UserName.Text);


                            //re1.Close();
                        }
                        else
                        {
                            p = 0;

                            //cmd1.CommandText = "Insert into Quiz_Result (std_id,std_name,std_fthr,std_cls,cntct_no) Select std_id,std_name,std_fthr,std_cls,cntct_no From student  where std_id='" + tb_UserName.Text + "'";
                            ////  cmd.Parameters.AddWithValue("@id",tb_UserName.Text);
                            //re.Close();
                            //re1.Close();
                            //cmd1.ExecuteNonQuery();
                            //conn.Close();
                            //MessageBox.Show("Inserted sucessfully");
                            //this.Close();
                            this.Hide();
                            Student_Main_Panel student = new Student_Main_Panel(textBox1.Text, p);
                            student.Show();
                        //    this.Close();
                        }






                    }
                    conn.Close();

                }//reader if

                else
                {

                    MessageBox.Show("Kindly Enter Valid Username or Password!!!");
                    textBox1.Text = string.Empty;
                    textBox2.Text = string.Empty;
                    conn.Close();
                }
            }
        
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            ValidateUserName();
        }



        //////////////////////////////////////////////////////////////Validations///////////////

        private bool ValidateUserName()
        {
            bool bStatus = true;
            if (textBox1.Text == "")
            {

                errorProvider1.SetError(textBox1, "Please enter UserName");
                bStatus = false;
            }


            else
            {

                int d = StudentIdChk();

                if (d == 1)
                {
                    errorProvider1.SetError(textBox1, "UserName Not Correct");
                    bStatus = false;
                    //return bStatus;
                }
                else
                    // errorProvider1.SetError(textBox1, "");

                    this.errorProvider1.SetError(textBox1, "");


            }

            //errorProvider1.SetError(textBox1, "");
            return bStatus;


        }
        private int StudentIdChk()
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
            conn.Open();
            da = new SqlDataAdapter();
            da.SelectCommand = new SqlCommand("select * from Login where UserName='" + textBox1.Text.Trim() + "' ", conn);
            dt = new DataTable();
            da.Fill(dt);
            if (dt.Rows.Count > 0)
            {

                return 0;
            }
            else
                return 1;

        }

        //validate password

        private bool ValidateUserPassword()
        {
            bool bStatus = true;
            if (textBox2.Text == "")
            {

                errorProvider1.SetError(textBox2, "Please enter Password");
                textBox1.Focus();
                bStatus = false;
            }


            else
            {

                int d = StudentPasswordchk();

                if (d == 1)
                {
                    errorProvider1.SetError(textBox2, "PassWord Not Correct");
                    bStatus = false;
                    //return bStatus;
                }
                else
                    // errorProvider1.SetError(textBox1, "");

                    this.errorProvider1.SetError(textBox2, "");


            }

            //errorProvider1.SetError(textBox1, "");
            return bStatus;


        }
        private int StudentPasswordchk()
        {

            if (textBox1.Text.Length > 0)
            {

                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
                conn.Open();

                cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "select Password from Login where UserName='" + textBox1.Text.Trim() + "' ";

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {

                    string pswd = dr["Password"].ToString().Trim();

                    if (pswd.Trim() == textBox2.Text.Trim())
                    {

                        return 0;
                    }
                    else
                        return 1;

                }
                else return 1;
             //   da = new SqlDataAdapter();
               // da.SelectCommand = new SqlCommand("select Password from Login where UserName='" + textBox1.Text.Trim() + "' ", conn);
                //dt = new DataTable();
                //da.Fill(dt);
                //ds = new DataSet();
                //da.Fill(ds);
                //string pswd = ds.Tables[0].Rows[0][0].ToString();
               
            }
            else
                return 1;
        }

        private void textBox1_Validating(object sender, CancelEventArgs e)
        {
            ValidateUserName();
        }

        private void textBox2_Validating(object sender, CancelEventArgs e)
        {
            ValidateUserPassword();
        }



    }
}

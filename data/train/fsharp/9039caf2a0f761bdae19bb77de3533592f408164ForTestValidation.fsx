
#r "Microsoft.Practices.EnterpriseLibrary.Validation.dll"
open Microsoft.Practices.EnterpriseLibrary.Validation
open Microsoft.Practices.EnterpriseLibrary.Validation.Validators

let v=new StringLengthValidator(1, RangeBoundaryType.Exclusive, 10, RangeBoundaryType.Exclusive, "The length of C_MC between  1 and 10") 
v.Validate("")


let va=new NotNullValidator()
let result=va.Validate(null)
result.IsValid
result
|>Seq.filter (fun a->a.Key="")
|>Seq.head
|>fun a->a.Message

//Microsoft.Practices.EnterpriseLibrary.Validation.ValidationFactory.CreateValidatorFromAttributes(
//Microsoft.Practices.EnterpriseLibrary.Validation.Validation.ValidateFromAttributes(

let va=new NotNullValidatorAttribute()
let result=va.Match("wx")
result
|>Seq.head
|>fun a->a.Message

//===========================================================
(*
using System.Collections.Generic;
using Microsoft.Practices.EnterpriseLibrary.Validation;
using Microsoft.Practices.EnterpriseLibrary.Validation.Validators;namespace WX.DataManage.RolePermissions
{
    public sealed class T_XT_GNJD_Validation : IEntityValidation //AEntityValidation<T_XT_GNJD_Validation>
    {
        #region Reference backup
        //It's right
        // public static Func<T_XT_GNJD, string> C_MCLengthFunc=f=>f.C_MC.Length>1 ? "The length of C_MC 1-10":null; 
        ////Invoke
        //C_MCLengthFunc.Invoke(new T_XT_GNJD());
        #endregion

        public static readonly T_XT_GNJD_Validation INS = new T_XT_GNJD_Validation();

        public IDictionary<string, IList<Validator>> GetValidators()
        {
            var dic = new Dictionary<string, IList<Validator>>();
            var validators = default(IList<Validator>);

            validators = new List<Validator>(){
                //new NotNullValidator("wx")
                new StringLengthValidator(1, RangeBoundaryType.Exclusive, 10, RangeBoundaryType.Exclusive, "The length of C_MC between  1 and 10") 
            };
            dic.Add("C_MC", validators);

            return dic;
        }


    }
}

*)
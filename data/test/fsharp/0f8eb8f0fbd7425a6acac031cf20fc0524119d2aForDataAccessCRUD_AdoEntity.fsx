
(*
http://www.dotnetfunda.com/articles/article504.aspx
CRUD Operations using ADO.net Entity Framework  with code waiting for download


http://msdn.microsoft.com/en-us/magazine/ee236639.aspx
EF v2 and Data Access Architecture Best Practices

http://blogs.msdn.com/efdesign/archive/2008/11/20/n-tier-improvements-for-entity-framework.aspx
N-Tier Improvements for Entity Framework
Published 20 November 08 05:33 AM | efdesign  

*)



(*

//--------------------------------------------------------------------------------
// Layered Architecture Sample: Expense Sample Application
// Developed by: Serena Yeoh
// 
// For updates, please visit http://www.codeplex.com/layersample
//--------------------------------------------------------------------------------
// THIS CODE AND INFORMATION ARE PROVIDED AS IS WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//--------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using ExpenseSample.Business.Entities;

// NOTE:
//
// Data access components are responsible for querying and persisting the data for
// the application. All database related processing should be done here.
//
// All the CRUD activities are done here in this component to isolate them from 
// higher level components in the layer. This should allow us to freely upgrade or 
// change data access technologies as required.
//
// It is not necessary that each Data Access Component to be mapped directly to an
// individual table. In larger systems, one DAC may manage the CRUD activities for
// one or more tables/Entities.
namespace ExpenseSample.Data
{
    public class ExpenseDataAccess 
    {
       
        /// <summary>
        /// Inserts an expense row.
        /// </summary>
        /// <param name="expense">An Expense object.</param>
        public Expense Create(Expense expense)
        {
            using (ExpenseEntities ctx = new ExpenseEntities())
            {
                try
                {
                    ctx.AddObject(Expense.EntitySetName, expense);
                    ctx.SaveChanges();
                }
                catch (Exception ex)
                {
                    Debug.WriteLine(ex.Message);
                }
            }

            return expense;
        }


        /// <summary>
        /// Updates an Expense row.
        /// </summary>
        /// <param name="expense">A Expense object.</param>
        public void Update(Expense expense)
        {
            EntityKey key = null;
            object original = null;

            using (ExpenseEntities ctx = new ExpenseEntities())
            {
                try
                {
                    key = ctx.CreateEntityKey(Expense.EntitySetName, expense);
                    if (ctx.TryGetObjectByKey(key, out original))
                    {
                        ctx.ApplyPropertyChanges(key.EntitySetName, expense);
                    }
                    ctx.SaveChanges();
                }
                catch (Exception ex)
                {
                    Debug.WriteLine(ex.Message);
                }
            }
        }


        /// <summary>
        /// Returns a set of Expenses that belongs to an employee
        /// </summary>
        /// <param name="employeeID">An EmployeeID.</param>
        /// <returns>A List of expenses.</returns>
        public List<Expense> SelectForEmployee(string employee)
        {
            List<Expense> resultsList = null;

            using (ExpenseEntities ctx = new ExpenseEntities())
            {
                resultsList =
                    (from expense in ctx.Expenses
                     where expense.Employee == employee
                     orderby expense.DateSubmitted descending
                     select expense).ToList();
            }
            
            return resultsList;

        }

        public List<Expense> SelectForApproval(string reviewer)
        {
            List<Expense> resultsList = null;

            using (ExpenseEntities ctx = new ExpenseEntities())
            {
                resultsList =
                    (from expense in ctx.Expenses
                     where expense.AssignedTo == reviewer && expense.IsCompleted == false
                     orderby expense.DateSubmitted descending
                     select expense).ToList();
            }

            return resultsList;

        }

        public List<Expense> SelectActive()
        {
            List<Expense> resultsList = null;

            using (ExpenseEntities ctx = new ExpenseEntities())
            {
                resultsList =
                    (from expense in ctx.Expenses
                     where expense.IsCompleted == false
                     orderby expense.DateSubmitted descending
                     select expense).ToList();
            }

            return resultsList;

        }

        public void Purge()
        {
            using (ExpenseEntities ctx = new ExpenseEntities())
            {
                List<Expense> resultList =
                    (from expense in ctx.Expenses
                     select expense).ToList();

                foreach (Expense expense in resultList)
                {
                    ctx.DeleteObject(expense);
                }

                try
                {
                    ctx.SaveChanges();
                }
                catch (Exception ex)
                {
                    Debug.WriteLine(ex.Message);
                }
            }
        }
    }
}


*)

////////////////////////////////////////////////////////////////////////////////////

(* http://www.dotnetfunda.com/articles/article504.aspx

Crud Functionality
Whenever a new Data Access Technology is introduced , all developers ask the first question, How can I perform CRUD (Create , Retrieve , Update and Delete) operations with technology. If same question is right now going in your mind, then welcome to this post.I will show you the complete example and working WPF application , source code attached with this post. In this example I have super simple and classical Employee table in my database. To generate the .edmx file based on this table , follow this simple steps 
?Right click your project name in Visual Studio 2008 and select Add / New Item from the context menu 
?From Data Categories in left pane select ADO.net Entity Model as shown in the figure 
?Give the valid name to your file 
?Follow simple wizard steps and viola , you are done. 
?Visual Studio has created new Entity Data Model file for you.

Please note that you can only add the edmx file in Visual Studio provided you have installed .net Framework 3.5 SP1 along with Visual Studio 2008 with SP1 

Now let us dive into some code as how you can perform these operations 

CREATE
Private Sub CreateEmployee(ByVal Emp As Employee) 


Dim key As EntityKey = Nothing 
   Try 
      Db.AddObject("Employee", Emp) 
      Db.SaveChanges() 
      key = Db.CreateEntityKey("Employee", Emp) 
    Catch ex As Exception 
       MessageBox.Show(ex.Message, "Error", MessageBoxButton.OK) 
    Finally 
       MessageBox.Show(String.Format("New Employee Created with Employee Id _{0}",       key.EntityKeyValues   (0).Value), "Employee Created", MessageBoxButton.OK) 
    End Try 
End Sub 


The above code will create a new employee record in Employee table. It accepts the parameter Emp , which is the Employee entity , based in edmx file. Visual Studio automatically generates this Partial class. Then we declare the EntityKey object , which will be used to get the Employee Id column value , which is an Identity Column in the table. The Db object variable is of Entities Type. The AddObject method add the new entity of Employee type in the logical schema, but still the changes are not committed in the database until the SaveChanges method is not executed. To get the identity column value of the last record inserted we used CreateEntityKey method which retrives the array of Entity keys and with their corresponding values. 

RETRIEVE
Dim ObjList 

Using db As New EFDemoEntities ObjList = (From Emp In db.Employee _ Select Emp).ToList 

End Using 

The Retrieve code is self explanatory which is Linq To Entities Queries which select all the columns from the Employee Entity 

UPDATE
Private Sub UpdateEmployee(ByVal Emp As Employee 
   Dim key As EntityKey key = Nothing 
   Dim OrignialEmplyee As Object OrignialEmplyee = Nothing 
   Try 
      key = Db.CreateEntityKey("Employee", Emp) 
      If Db.TryGetObjectByKey(key, OrignialEmplyee) Then 
         Db.ApplyPropertyChanges(key.EntitySetName, Emp) 
         Db.SaveChanges() 
      End If 
   Catch ex As Exception    

   MessageBox.Show(ex.Message, "Error", MessageBoxButton.OK) 
   Finally 
      MessageBox.Show("Updated") 
   End Try 
End Sub 

In the UpdateEmployee method again we accept the Emp parameter which is of Employee Entity Type. We try to retrieve the orignal Employee entity object using TryGetObjectByKey method and passes that retrieved object by reference to the OrigninalEmployee variable. Further then by calling ApplyPropertyChanges method , we overwrite the properties of original object with the updated object's properties. SaveChanges method then commits these changes to the underlying database. 

DELETE

Private Sub DeleteEmployee(ByVal Emp As Employee) 
   Try 
      Db.DeleteObject(Emp)
      Db.SaveChanges()
   Catch ex As Exception 
         MessageBox.Show(ex.Message, "Error", MessageBoxButton.OK) 
   Finally 
      MessageBox.Show("Deleted")
   End Try 
End Sub 
This method executes the DeleteObject method with Employee entity as its paramater. The SaveChanges method commits those changes to the database. 

CONCLUSION
The Entity objects are front end interface to EDM Types which enables Object Oriented Programming to use them and access the data from the database in object fashioned rather than in releational way.This technology holds lots of promise as new Data Services (Astoria) , is also based on Entity Framework. Download the code from here. Please rename the file extension from .doc to .rar. The zip file also have the Db.rar file in the Database folder. Attach this file to your SQL Server Database and change the connection string in the app.config file to suit to your development needs. I hope you would have enjoy reading this post. Do let me know your thoughts on it. Happy coding. Follow me on twitter



*)


//////////////////////////////////////////////////////////////////////


(*

Insert
using (TestDBEntities ctx = new TestDBEntities())
{
    //Create new Emp object
    Emp e = new Emp() { Name = "Test Employee" };
    //Add to memory
    ctx.AddToEmp(e);
    //Save to database
    ctx.SaveChanges();
}

Update
using (TestDBEntities ctx = new TestDBEntities())
{
    //Get the specific employee from Database
    Emp e = (from e1 in ctx.Emp
             where e1.Name == "Test Employee"
             select e1).First();
    //Change the Employee Name in memory
    e.Name = "Changed Name";
   //Save to database

    ctx.SaveChanges();
}

Delete
using (TestDBEntities ctx = new TestDBEntities())
{
    //Get the specific employee from Database
    Emp e = (from e1 in ctx.Emp
             where e1.Name == "Test Employee"
             select e1).First();

    //Delete it from memory
    ctx.DeleteObject(e);

    //Save to database
    ctx.SaveChanges();
}

In my next post I will write about “how to handle CRUD with Relationship”.

*)

////////////////////////////////////////////////////////////////////////////////

(*

Object Services is the set of components that interact with .NET entity classes. For example, if you've defined "Customer" and "Order" entities in your conceptual model, you can run code generation as part of Visual Studio to create .NET classes for these entity types. Using these and Object Services, you can perform these operations:

Code Snippet
// Insert

using(NorthwindContext context = new NorthwindContext())
{
    Customer c = Customer.CreateCustomer("ABCDE", "MSFT");
    context.AddToCustomers(c);
    context.SaveChanges();
}

// Update
using(NorthwindContext context = new NorthwindContext())
{
    Customer c = context.Customers.Where(...);
    c.Name = "NewName";
    context.SaveChanges();
}

// Delete
using(NorthwindContext context = new NorthwindContext())
{
    Customer c = context.Customers.Where(...);
    context.DeleteObject(c);
    context.SaveChanges();
}
If you want a generic method to do this, it really depends on what other infromation you have available. For "Insert" cases, you need to have the EntitySet name available (i.e. does my Customer go into the "ActiveCustomers" EntitySet or the "ArchivedCustomers" EntitySet. Then you can just use the "AddObject()" method on the ObjectContext. For "Update", you can use the ObjectContext.ApplyPropertyChanges() method or just modify your entity directly and the changes are tracked. For delete cases, you can simply call ObjectContext.DeleteObject().

Jeff


*)

////////////////////////////////////////////////////


(*http://blogs.msdn.com/adonet/archive/2007/03/01/object-services-write-less-code.aspx

Object Services – Write less code
Published 01 March 07 06:35 PM | elisaj 
 

One of the main features of the Entity Framework revolves around Object Services. The main points of Object services are to write less code and allow programmers to program against objects to access the data that’s stored in a database or possibly anywhere. We can consider this feature as a road to CRUD; where CRUD represents Create, Read, Update, and Delete operations against data, except this feature provides more than just a simple road.

How this works?

Object Services is the top layer in the Entity Framework. The framework consists of three district layers: EDM, mapping, and the source layer. The important layer for Object Services is the EDM layer (also label CSDL). The Entity Data Model (EDM) layer brings the concepts of entities to stored data. Currently in version 1.0 of the ADO.NET Entity Framework there is a 1:1 relationship between the EDM and Objects Services. Object Services is the realization of Objects from those described Entities. The table below shows the different layers.




Another important feature for Object Services and the Entity Framework in general comes with the knowledge that the Objects Services gives access to the entity type information in the lower layers of the Framework. By providing access to the lower layers of the Entity Framework, customers gain access to specific type information, relationship information, and basic data readers and writers to the data. One particular scenario may be translating between data sources, and one way to do this would be to gain access to the type information.

What can you do with Object Services?

Here’s a bullet list of some of the normal operations which object services can provide:

·         Query using LINQ or Entity SQL
·         CRUD
·         State Management – change tracking with events
·         Lazy loading
·         Inheritance
·         Navigating relationships

More features of Object Services allow for data conflicts resolution. For example, Object Services supports:

·         Optimistic concurrency
·         Identity resolution -  keeping on copy of the object even from several different queries
·         Merging
·         Refreshing data with overwrite options (ie: server wins or client wins)

These are important concepts to understand because the Entity Framework isn’t just designed to do CRUD operations; the Entity Framework is designed to scale to large or even mission critical applications. Given a large or small program, programming against a service model with consistent error handling, data handling, and easy access to data layers allow programs to have a robust experience. These features also allow programmers to work on features instead of core application plumbing.

Let’s dive into some examples:

Here’s a simple sample using a query with Entity SQL that does a foreach over objects materialized from the EDM.

    using (NorthwindEntities northWind = new NorthwindEntities())
    {
        // Calling CreateQuery materializes objects
        ObjectQuery<Products> products =
            northWind.CreateQuery<Products>(
                "SELECT VALUE p FROM Products AS p");
        foreach (Products p in products)
        {
            Console.WriteLine(p.ProductName);
        } // foreach
    }   // using Northwind Entities

 

Same sample using LINQ.

    using (NorthwindEntities northWind = new NorthwindEntities())
    {
        var products = from p in northWind.Products select p;
        foreach (Products product in products)
        {
            Console.WriteLine(product.ProductName);
        }   // for each
    }   // using

CRUD Examples:

The next example does a LINQ query retrieving all the products that belong to a category called beverages and then just for kicks, changes the discontinued products that have unit prices to $1.25.  When looking at the samples,  notice that there’s a call to save changes which only pushes the modified Objects back to the the data source.

    using (NorthwindEntities northWind = new NorthwindEntities())
    {
        // do a LINQ query which finds all the products that fall
        // under the category beverages
        var products = from p in northWind.Products
                       where p.Categories.CategoryName == "beverages"
                       select p;
 
        foreach (Products product in products)
        {
            // with lazy loading, object references must
            // be loaded first, otherwise an exception is thrown.
            // this allows for a reduced number of trips to the source.
            Console.WriteLine("{0}\tDiscontinued: {1}",
                                product.ProductName,
                                product.Discontinued);
           
            // just for fun, if the product is discontinued,
            // then let's set the unit price to $1.25
            if (product.Discontinued)
            {
                product.UnitPrice = (decimal)1.25;
            }   // if           
        }   // for each
 
        // notice, that until we call save changes
        // the data in the database or source is not updated.
        northWind.SaveChanges();
    }   // using

One more example with conflict:

The final example is a little longer, but shows optimistic concurrency and one way to deal with the conflict. conflicts. Also note that to make this work, which also shows the flexibility in the EDM, the entity set Categories must have an attribute flagged with ConcurrencyMode set to “fixed”.

// Property set in the EDM or CSDL file.
<ProperyName = “CategoryName” …(other attributes) ConcurrencyMode=”fixed”/>

 

Code example:

    // save the category id out for retrieval later in this example.
    int cateID = 0;
 
    // create an instances of a new category and add to the list
    // of categories.
    using (NorthwindEntities northWind = new NorthwindEntities())
    {
        // create a new category
        Categories catNew = new Categories();
        catNew.CategoryName = "Blog Example";
        catNew.Description = "Blog description";
 
        // add to object context, and save changes
        northWind.AddObject(catNew);
        northWind.SaveChanges();
 
        // cache away the category ID.
        cateID = catNew.CategoryID;
    } // using
 
    // create different object context variables
    using (NorthwindEntities northWind1 = new NorthwindEntities())
    using (NorthwindEntities northWind2 = new NorthwindEntities())
    {
        // using a direct query from the categories item from
        // northwind 2, get the id out.
        Categories cat1 = northWind1.CreateQuery<Categories>(
           "SELECT VALUE c FROM Categories AS c WHERE c.CategoryID=@id",
           new ObjectParameter("id", cateID)).First();
        cat1.CategoryName = "category 1";
 
        // using a direct query from the categories item from
        // northwind 2, get the id out.
        Categories cat2 = northWind2.CreateQuery<Categories>(
            "SELECT VALUE c FROM Categories AS c WHERE c.CategoryID=@id",
            new ObjectParameter("id", cateID)).First();
        cat2.CategoryName = "category 2";
       
        // save northwind 2 so we can create a conflict.
        northWind2.SaveChanges();
 
        try
        {
            // with the second save changes, the services notices the data
            // that’s out of sync and throws an exception.
            northWind1.SaveChanges();
        }   // try  
        catch(OptimisticConcurrencyException)
        {
            Console.WriteLine("Caught optimistic concurrency exception");
           
        }   // catch
 
        // One way of fixing the violation is to
        // refresh the first object context, then
        // change the category name again
        // and save changes.
        northWind1.Refresh(RefreshMode.StoreWins, cat1);
        cat1.CategoryName = "category 1";
        northWind1.SaveChanges();
 
        // for the sake of our database, let's delete the
        // object, and not to forget to refresh
        // and save changes
        northWind2.Refresh(RefreshMode.StoreWins, cat2);
        northWind2.DeleteObject(cat2);
        northWind2.SaveChanges();
    } // using


*)
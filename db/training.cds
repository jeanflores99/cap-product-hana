namespace com.training;


using {
    cuid,
    managed,
    Country
} from '@sap/cds/common';

type EmailsAddresses_01 : many {
    kind  : String;
    email : String;
}

type EmailsAddresses_02 : {
    kind  : String;
    email : String;
}

entity Orders {
    key ClientEmail : String(65);
        FirstName   : String(30);
        LastName    : String(30);
        CreateOn    : Date;
        Reviewed    : Boolean;
        Approved    : Boolean;
        Country     : Country;
        Status      : String(1);


}

entity Emails {
    email_01 :      EmailsAddresses_01;
    email_02 : many EmailsAddresses_02;
    email_03 : {
        kind  : String;
        email : String;

    }
}

// entity order : cuid {
//     clientGender : Gender;
//     status       : Integer enum {
//         submitted = 1;
//         fulfiller = 2;
//         shipped   = 3;
//         cancel    = -1;
//     };
//     Priority     : String @assert.range enum {
//         high;
//         medium;
//         low;
//     };
//     Items        : Composition of many OrderItems
//                        on Items.order = $self;
// }

// Select
// entity SelfProducts  as select from Products;

// entity SelfProducts1 as
//     select from Products {
//         *
//     };

// entity SelfProducts2 as
//     select from Products {
//         Name,
//         Price,
//         Quantity
//     };

// entity SelfProducts3 as
//     select from Products
//     left join ProductReview
//         on Products.Name = ProductReview.Name
//     {
//         Rating,
//         Products.Name,
//         sum(
//             Products.Price
//         ) as TotalPrice
//     }
//     group by
//         Rating,
//         Products.Name
//     order by
//         Rating;


// // projection


entity Course {
    key id            : UUID;
        CourseStudent : Association to many CourseStudent
                            on CourseStudent.Course = $self;
}

entity Student {
    key id      : UUID;
        Student : Association to many CourseStudent
                      on Student.Student = $self;
}

entity CourseStudent {
    key id      : UUID;
        Student : Association to one Student;
        Course  : Association to one Course;
}


// //entitades con parametro
// entity ParamProducts(pName : String)     as
//     select from Products {
//         Name,
//         Price,
//         Quantity
//     }
//     where
//         Name = :pName;

// entity ProjParamProducts(pName : String) as projection on Products
//                                             where
//                                                 Name = :pName;

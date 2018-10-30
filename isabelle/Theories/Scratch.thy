theory Scratch
  imports Main
begin
declare [[names_short]]
datatype nat = 0 | Suc nat
fun add :: "nat \<Rightarrow> nat \<Rightarrow> nat" where 
"add 0 n = n" | 
"add (Suc m) n = Suc (add m n)"

lemma add_02[simp]: "add m 0 = m"
  apply(induction m)
  apply(auto)
done

datatype 'a list = Nil | Cons 'a "'a list" 
fun app :: "'a list \<Rightarrow> 'a list \<Rightarrow> 'a list" where
"app Nil ys = ys" |
"app (Cons x xs) ys = Cons x (app xs ys)"

fun rev :: "'a list \<Rightarrow> 'a list" where
"rev Nil = Nil" |
"rev (Cons x xs) = app (rev xs) (Cons x Nil)"

value "rev (Cons False (Cons True Nil))"

lemma app_Nil2 [simp]: "app xs Nil = xs"
  apply(induction xs)
  apply(auto)
  done

lemma app_assoc [simp]: "app xs (app ys zs) = app (app xs ys) zs"
  apply(induction xs) 
  apply(auto)
  done

lemma rev_app [simp]: "rev (app xs ys) = app (rev ys) (rev xs)"
  apply(induction xs)
  apply(auto)
  done

theorem rev_rev [simp]: "rev (rev xs) = xs"
  apply(induction xs)
  apply(auto)
  done

(* Exercises 2.1-2.5 *)

value "1+(2::nat)"
value "1+(2::int)"
value "1-(2::nat)"
value "1-(2::int)"

lemma add_suc[simp]: "add x (Suc y) = Suc (add x y)"
  apply(induction x)
  apply(auto)
  done

theorem add_com: "add x y = add y x"
  apply(induction x)
  apply(auto)
  done

theorem add_assoc: "add (add x y) z = add x (add y z)"
  apply (induction x) 
  apply (auto) 
  done

fun double :: "nat => nat" where 
  "double 0 = 0" | 
  "double (Suc x) = Suc (Suc (double x))"

theorem add_double: "double x = add x x"
  apply (induction x) 
  apply (auto) 
  done

fun count :: "'a => 'a list => nat" where
  "count x Nil = 0" | 
  "count x (Cons y xs) = (if x=y then 1 else 0)"

end

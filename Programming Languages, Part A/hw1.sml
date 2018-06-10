fun is_older((p1, p2, p3), (n1, n2, n3)) =
  if (n1*100 + n2*10 + n3) > (p1*100 + p2*10 + p3)
  then true
  else false

fun number_in_month(lst: (int*int*int) list, m) =
  if null lst
  then 0
  else
    let 
      val head = hd lst
      val next = number_in_month(tl lst, m)
    in
      if #2 head = m
      then 1 + next
      else next
    end

  fun number_in_months(lst: (int*int*int) list, ms: int list) =
    if null ms
    then 0
    else number_in_month(lst, hd ms) + number_in_months(lst, tl ms)

  fun dates_in_month(lst: (int*int*int) list, m) =
    if null lst
      then []
    else
      let 
        val head = hd lst
        val next = dates_in_month(tl lst, m)
      in
        if #2 head = m
        then head::next
        else next
      end

  fun dates_in_months(lst: (int*int*int) list, ms: int list) =
    if null ms
    then []
    else dates_in_month(lst, hd ms) @ dates_in_months(lst, tl ms)

  fun get_nth(lst: 'a list, n: int) =
    if n = 1
    then hd lst
    else get_nth(tl lst, n - 1)

  fun date_to_string(y: int, m: int, d: int) =
    let
      val arr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in
      get_nth(arr, m) ^ " " ^ Int.toString(d) ^ ", " ^ Int.toString(y)
    end

  (*
  fun number_before_reaching_sum(n: int, lst: int list) =
    let
      fun sumf(n: int, lst: int list) =
        if n = 0
        then 0
        else hd lst + sumf(n - 1, tl lst)
      fun getn(n: int, i: int, lst: int list) =
        if sumf(i, lst) >= n
        then i - 1
        else getn(n, i + 1, lst)
    in
      getn(n, 1, lst)
    end
  *)
  fun number_before_reaching_sum(n: int, lst: int list) =
    let
      fun findnum(n: int, i: int, lst: int list, sum: int) =
        if sum + (hd lst) >= n
        then i - 1
        else findnum(n, i + 1, tl lst, sum + (hd lst)) 
    in
      findnum(n, 1, lst, 0)
    end


  fun what_month(n: int) =
    let
      val arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
      number_before_reaching_sum(n, arr) + 1
    end

  fun month_range(d1: int, d2: int) =
    if d1 > d2
    then []
    else what_month(d1)::month_range(d1 + 1, d2)

  fun oldest(lst: (int*int*int) list) =
    if null lst
    then NONE
    else
      let
        val head = hd lst
        val next = oldest(tl lst)
        val nextVal = if next <> NONE then valOf(next) else (9999, 9999, 9999)
      in
        if is_older(head, nextVal)
        then SOME head
        else next
      end

---
layout: main/blog-post
title: Introspecting Pallet (part II)
author: Antoni Batchelli
section: blog
summary: Pallet 0.8.0-beta.11, along with pallet-repl 0.8.0-beta.2
         provide a set of functions to introspect Pallet actions,
         either before executing them by asking Pallet what it is
         going to do, and after executing by asking Pallet what it did
         and how it went.
---

In the [previous post](/blog/new-introspection-features/) we saw how Pallet
is able to explain what actions will it execute, and what scripts will
it run, given a plan or phase. This time we'll discuss how can we know
what pallet did during a session with `explain-session`.

Let's assume we have the following code with two groups: `:good` and
`:bad`, that have two phases each: `:first` and `:second`. The `:good`
group will run correctly, whereas the `:bad` group will try to run a
broken script in the `:second` phase. Here is the code:

```clojure
(ns session-results
  (:require [pallet.actions :as actions]
            [pallet.api :as api]))

(def good-group
  (api/group-spec
   "good"
   :extends *base-spec*
   :phases
   {:first (api/plan-fn (actions/exec-script (println "first!")))
    :second (api/plan-fn
                (actions/exec-checked-script
                 "say hello!"
                 ("echo" "hello world!")))}))

(def bad-group
  (api/group-spec
   "bad"
   :extends *base-spec*
   :phases
   {:first (api/plan-fn (actions/exec-script (println "first!")))
    :second (api/plan-fn
                (actions/exec-script (println "hello world!"))
                (actions/exec-checked-script
                 "fail!"
                 ("exit -1")))}))
```

As we saw in the previous post, with the code above we can ask Pallet
what it is going to do for the first phase on `bad-group`:

```clojure
session-results> (explain-phase bad-group :phase :first)
```

resulting in:

```
NODE: ["mock-node" "bad" "0.0.0.0" :ubuntu :os-version "12.04"]
ACTION: pallet.actions/exec-script* of type script executed on target
  FORM:
    (pallet.actions/exec-script* "echo first!")
  SCRIPT:
    | echo first!
```

Easy enough. `explain-phase` told us that pallet will execute a single
action on the target node, and that this action, `exec-script*`,
will result in running:

```
echo first!
```

But the question now that we are trying to answer is not what will
Pallet do, but to know instead what Pallet has done. Given the code
above, we'll create a couple of nodes of in each group with while
storing the results in the session. We'll omit the bootstrap code for
clarity. Remember that in the `bad-group`, the phase named `:second`
will fail:

```clojure
(def r (api/converge {good-group 2 bad-group 2} :phase [:first :second]))
```

Let's first get a summary to see how things went:

```clojure
(explain-session r :show-detail false)
```

which results in:

```
PHASES: first, second
GROUPS: good, bad
ACTIONS:
  PHASE first:
    GROUP good:
      NODE 192.168.56.135: OK
      NODE 192.168.56.136: OK
    GROUP bad:
      NODE 192.168.56.137: OK
      NODE 192.168.56.134: OK
  PHASE second:
    GROUP good:
      NODE 192.168.56.136: OK
      NODE 192.168.56.135: OK
    GROUP bad:
      NODE 192.168.56.137: ERROR
      NODE 192.168.56.134: ERROR
```

This is what we expected: the `:second` phase would fail for the nodes
in `group-bad`. Everything else seems to have worked. 

Let's get all the detail about what happened. We do so by running:

```clojure
(explain-session r)
```

which results in:

```
session-results> (explain-session r)
PHASES: first, second
GROUPS: good, bad
ACTIONS:
  PHASE first:
    GROUP good:
      NODE 192.168.56.135:
        ACTION #1
          SCRIPT:
          | #!/usr/bin/env bash
          | echo first!
          | exit $?
          EXIT CODE: 0
          OUTPUT:
          | first!
      NODE 192.168.56.136:
        ACTION #1
          SCRIPT:
          | #!/usr/bin/env bash
          | echo first!
          | exit $?
          EXIT CODE: 0
          OUTPUT:
          | first!
    GROUP bad:
      NODE 192.168.56.137:
        ACTION #1
          SCRIPT:
          | #!/usr/bin/env bash
          | echo first!
          | exit $?
          EXIT CODE: 0
          OUTPUT:
          | first!
      NODE 192.168.56.134:
        ACTION #1
          SCRIPT:
          | #!/usr/bin/env bash
          | echo first!
          | exit $?
          EXIT CODE: 0
          OUTPUT:
          | first!
  PHASE second:
    GROUP good:
      NODE 192.168.56.136:
        ACTION #1
          SCRIPT:
          | #!/usr/bin/env bash
          | echo 'say hello! (session_results.clj:14)...';
          | {
          | echo hello world!
          |  } || { echo '#> say hello! (session_results.clj:14) : FAIL'; exit 1;} >&2 
          | echo '#> say hello! (session_results.clj:14) : SUCCESS'
          | 
          | exit $?
          EXIT CODE: 0
          OUTPUT:
          | say hello! (session_results.clj:14)...
          | hello world!
          | #> say hello! (session_results.clj:14) : SUCCESS
      NODE 192.168.56.135:
        ACTION #1
          SCRIPT:
          | #!/usr/bin/env bash
          | echo 'say hello! (session_results.clj:14)...';
          | {
          | echo hello world!
          |  } || { echo '#> say hello! (session_results.clj:14) : FAIL'; exit 1;} >&2 
          | echo '#> say hello! (session_results.clj:14) : SUCCESS'
          | 
          | exit $?
          EXIT CODE: 0
          OUTPUT:
          | say hello! (session_results.clj:14)...
          | hello world!
          | #> say hello! (session_results.clj:14) : SUCCESS
    GROUP bad:
      NODE 192.168.56.137:
        ACTION #1
          SCRIPT:
          | #!/usr/bin/env bash
          | echo hello world!
          | exit $?
          EXIT CODE: 0
          OUTPUT:
          | hello world!
        ACTION #2
          SCRIPT:
          | #!/usr/bin/env bash
          | echo 'fail! (session_results.clj:27)...';
          | {
          | exit -1
          |  } || { echo '#> fail! (session_results.clj:27) : FAIL'; exit 1;} >&2 
          | echo '#> fail! (session_results.clj:27) : SUCCESS'
          | 
          | exit $?
          EXIT CODE: 255
          OUTPUT:
          | fail! (session_results.clj:27)...
          ERROR:
            TYPE: :pallet-script-excution-error
            MESSAGE: 192.168.56.137 Error executing script
            OUTPUT: fail! (session_results.clj:27)...
      NODE 192.168.56.134:
        ACTION #1
          SCRIPT:
          | #!/usr/bin/env bash
          | echo hello world!
          | exit $?
          EXIT CODE: 0
          OUTPUT:
          | hello world!
        ACTION #2
          SCRIPT:
          | #!/usr/bin/env bash
          | echo 'fail! (session_results.clj:27)...';
          | {
          | exit -1
          |  } || { echo '#> fail! (session_results.clj:27) : FAIL'; exit 1;} >&2 
          | echo '#> fail! (session_results.clj:27) : SUCCESS'
          | 
          | exit $?
          EXIT CODE: 255
          OUTPUT:
          | fail! (session_results.clj:27)...
          ERROR:
            TYPE: :pallet-script-excution-error
            MESSAGE: 192.168.56.134 Error executing script
            OUTPUT: fail! (session_results.clj:27)...
```

Now we see, for each phase, for each group, and for each node in each
group, what actions where executed (in order), what was the script
run, the exit code for such script and the output of the script
execution. If there are errors we also get information about these errors.


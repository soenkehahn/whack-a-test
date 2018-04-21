primitive Output
  fun addNumbers(env: Env, x: I64, y: I64) =>
    env.out.print(x.string() + " + " + y.string() + " = " + (x+y).string())

class Handler is StdinNotify

  let env: Env
  var arr: String val = ""

  new iso create(env': Env) =>
    env = env'

  fun ref apply(data: Array[U8 val] iso) =>
    arr = arr.add(String.from_iso_array(consume data))

  fun dispose() =>
    try
      let words = arr.split(" ")
      let x: I64 = words(0)?.i64()?
      let y: I64 = words(1)?.i64()?
      Output.addNumbers(env, x, y)
    end

actor Main
  new create(env: Env) =>
    let handler: Handler iso = Handler.create(env)
    try
      let x: I64 = env.args(1)?.i64()?
      let y: I64 = env.args(2)?.i64()?
      Output.addNumbers(env, x, y)
    else
      env.input.apply(consume handler)
    end

actor Main
  new create(env: Env) =>
    try
      let x: I64 = env.args(1)?.i64()?
      let y: I64 = env.args(2)?.i64()?
      env.out.print(x.string() + " + " + y.string() + " = " + (x+y).string())
    end

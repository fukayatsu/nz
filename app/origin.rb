module Origin
  DEFAULT_GENE = [
    :nop1, :nop1, :nop1, :nop1, # 母セルコード開始テンプレート
      :adrb, :nop0, :nop0, :nop0, :nop0, # 母セルコード開始テンプレートと相補
      :sub_ac,
      :movab,
      :movcd,
      :adrf, :nop0, :nop0, :nop0, :nop1, # コード終了テンプレートと相補
      :inc_a,
      :sub_ab, # 母セルのコードサイズをCXに保存
      :nop0, :nop0, :nop1, :nop0, # 自己複製ループのアドレステンプレート
        :mal,
        :call, :nop0, :nop0, :nop1, :nop1, # コピープロシージャ
        :divide,
        :jmp, :nop1, :nop1, :nop0, :nop1, # 自己複製ループのアドレステンプレート
      :ifz, # ダミー
      :nop1, :nop1, :nop0, :nop0, # コピープロシージャ開始
        :pushax,
        :pushbx,
        :pushcx,
        :nop1, :nop0, :nop1, :nop0, # コピーループ開始
          :movii,
          :dec_c,
          :ifz,
            :jmp, :nop0, :nop1, :nop0, :nop0, # コピープロシージャ終了へ
          :inc_a,
          :inc_b,
          :jmp, :nop0, :nop1, :nop0, :nop1, # コピーループ続行
      :ifz, # ダミー
      :nop1, :nop0, :nop1, :nop1, # コピープロシージャ終了
      :popcx,
      :popbx,
      :popax,
      :ret,
    :nop1, :nop1, :nop1, :nop0, # コード終了テンプレート
    :ifz # ダミー
  ]
end
